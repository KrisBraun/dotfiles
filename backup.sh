#!/usr/bin/env bash
# Pre-wipe backup: saves everything on this Mac that is NOT already in GitHub,
# iCloud, Google Drive or 1Password, so the drive can be erased.
#
#   ./backup.sh --dry-run        # show what would be saved; writes nothing
#   ./backup.sh                  # save to Google Drive: My Drive/Mac Backup/<computer>-<date>
#   ./backup.sh /Volumes/USB/x   # save somewhere else
#   ./backup.sh --with-transcripts   # also keep Claude Code session transcripts (~2.5 GB)
#
# What it writes into the destination folder:
#   git/<repo>.bundle       local-only branches + every stash (anything not on origin/main)
#   git/wip/<worktree>.*    uncommitted changes (patch) and untracked files (tgz) per worktree
#   repos.tsv               every repo's path, remote and branch, for restore.sh to re-clone
#   files/home/...          personal folders and loose files that are not in a cloud
#   files/code-loose.tgz    non-git folders and loose files under ~/code
#   files/config/...        app settings (Claude Code, Alfred, OBS, Raycast, fonts, launch agents)
#   inventory/              lists of installed apps and tools, for reference
#   secrets.dmg             AES-256 encrypted image: keys, tokens, credentials, signing identities
#
# Credentials never go into the plain folders: anything that looks like a key or
# .env file is routed into secrets.dmg instead.
set -uo pipefail

DRY=0 TRANSCRIPTS=0 DEST=""
for a in "$@"; do
  case "$a" in
    -n|--dry-run) DRY=1 ;;
    --with-transcripts) TRANSCRIPTS=1 ;;
    -h|--help) sed -n '2,23p' "$0"; exit 0 ;;
    -*) echo "unknown option $a" >&2; exit 2 ;;
    *) DEST="$a" ;;
  esac
done

if [ -z "$DEST" ]; then
  GD=$(ls -d "$HOME"/Library/CloudStorage/GoogleDrive-*/"My Drive" 2>/dev/null | head -1)
  [ -n "$GD" ] || { echo "Google Drive is not mounted; pass a destination folder." >&2; exit 1; }
  DEST="$GD/Mac Backup/$(scutil --get ComputerName | tr ' ' '-')-$(date +%Y-%m-%d)"
fi

# Files bigger than this are listed in the log instead of copied (build artefacts, installers).
MAXFILE=$((200 * 1024 * 1024))
# Database dumps that may hold other people's data (e.g. client or patient DBs). Listed, never copied.
SKIP_RE='_db_backup\.sql$|_staging_backup\.sql$'
# Anything matching this goes to secrets.dmg, never to the plain folders.
SECRET_RE='(^|/)(\.env(\..+)?|\.dev\.vars.*|.+\.(pem|p8|p12|pfx|jks|keystore|mobileprovision|provisionprofile)|client[_-]secret.*\.json|.*credentials.*\.json|key\.properties|google-services\.json|GoogleService-Info\.plist)$'
# Plot repos regenerate their env files from 1Password (`pnpm get-env`); don't copy them.
NO_ENV_COPY_RE='github\.com[:/]plotday/'

TAR_EXCLUDES=(--exclude node_modules --exclude .git --exclude .dart_tool --exclude .gradle
  --exclude Pods --exclude DerivedData --exclude .next --exclude .turbo --exclude .wrangler
  --exclude .venv --exclude venv --exclude __pycache__ --exclude .output --exclude .wxt
  --exclude target --exclude .terraform --exclude .DS_Store
  --exclude '.env' --exclude '.env.*' --exclude '.dev.vars*' --exclude '*.pem' --exclude '*.p8'
  --exclude '*.p12' --exclude '*.pfx' --exclude '*.jks' --exclude '*.keystore'
  --exclude 'client_secret*.json' --exclude 'client-secret*.json' --exclude '*.mobileprovision'
  --exclude '*.provisionprofile' --exclude '*_db_backup.sql' --exclude '*_staging_backup.sql')

# Top-level folders in ~ that are already in a cloud, or are rebuildable.
# (secure and vpn hold keys: they go to secrets.dmg only.)
HOME_SKIP=" Library Applications code dotfiles Notes Desktop Documents Google Drive iCloud Drive (Archive) Public go perl5 fvm secure vpn "

bold() { printf '\n\033[1m%s\033[0m\n' "$*"; }
LOG=/dev/null
log() { echo "$*" | tee -a "$LOG" >&2; }
warn() { printf '\033[33m! %s\033[0m\n' "$*" | tee -a "$LOG" >&2; }
id_of() { echo "${1#"$HOME"/}" | sed 's#/#__#g'; }   # ~/code/plot/x -> code__plot__x

if [ $DRY = 0 ]; then
  mkdir -p "$DEST"/{git/wip,files/home,files/config,inventory} || exit 1
  LOG="$DEST/backup.log"; : > "$LOG"
  : > "$DEST/repos.tsv"
fi
bold "Backing up to: $DEST $([ $DRY = 1 ] && echo '(DRY RUN, nothing written)')"

SECRETS=()   # absolute paths destined for secrets.dmg

# ---------------------------------------------------------------------------
bold "1/6  Git repositories"
REPOS=$( { find "$HOME/code" -maxdepth 4 \( -name node_modules -o -name worktrees -o -name .repro -o -name '*-worktrees' \) -prune \
             -o -name .git -print 2>/dev/null; echo "$HOME/dotfiles/.git"; echo "$HOME/Notes/.git"; } \
         | while IFS= read -r g; do [ -e "$g" ] && dirname "$g"; done | sort -u)
year_ago=$(date -v-1y +%F)

while IFS= read -r r; do
  [ -n "$r" ] || continue
  rel=${r#"$HOME"/}; id=$(id_of "$r")
  url=$(git -C "$r" remote get-url origin 2>/dev/null || true)
  branch=$(git -C "$r" branch --show-current 2>/dev/null)
  last=$(git -C "$r" log -1 --all --format=%cs 2>/dev/null)
  # restore.sh clones every uncommented line; repos untouched for a year start commented out.
  prefix=""; [[ "${last:-0000}" < "$year_ago" ]] && prefix="#"
  [ $DRY = 0 ] && printf '%s%s\t%s\t%s\n' "$prefix" "$rel" "${url:-<no-remote>}" "$branch" >> "$DEST/repos.tsv"

  base=""
  if [ -n "$url" ]; then
    for b in origin/HEAD origin/main origin/master; do
      git -C "$r" rev-parse -q --verify "$b^{commit}" >/dev/null 2>&1 && { base=$b; break; }
    done
  fi
  nstash=$(git -C "$r" stash list 2>/dev/null | wc -l | tr -d ' ')
  if [ -n "$url" ]; then
    nlocal=$(git -C "$r" rev-list --count --branches --not --remotes 2>/dev/null || echo 0)
  else
    nlocal=$(git -C "$r" rev-list --count --all 2>/dev/null || echo 0)
  fi

  # Bundle: everything not already on origin/main (or the whole repo if it has no remote).
  if [ "${nlocal:-0}" -gt 0 ] || [ "$nstash" -gt 0 ]; then
    log "  bundle  $rel  (${nlocal} local-only commits, ${nstash} stashes$([ -z "$url" ] && echo ', NO REMOTE'))"
    if [ $DRY = 0 ]; then
      i=0
      for h in $(git -C "$r" stash list --format=%H); do git -C "$r" update-ref "refs/pre-wipe/stash-$i" "$h"; i=$((i+1)); done
      if [ -n "$base" ]; then
        git -C "$r" bundle create "$DEST/git/$id.bundle" --branches --tags --glob='refs/pre-wipe/*' --not "$base" 2>>"$LOG" \
          || warn "bundle failed: $rel"
      else
        git -C "$r" bundle create "$DEST/git/$id.bundle" --all 2>>"$LOG" || warn "bundle failed: $rel"
      fi
      git -C "$r" for-each-ref --format='%(refname)' refs/pre-wipe | while read -r ref; do git -C "$r" update-ref -d "$ref"; done
    fi
  fi

  # Uncommitted work in the main checkout and every worktree.
  git -C "$r" worktree list --porcelain 2>/dev/null | sed -n 's/^worktree //p' | while IFS= read -r wt; do
    [ -d "$wt" ] || continue
    [ -n "$(git -C "$wt" status --porcelain --ignore-submodules 2>/dev/null)" ] || continue
    wid=$(id_of "$wt")
    log "  wip     ${wt#"$HOME"/}"
    [ $DRY = 1 ] && continue
    git -C "$wt" diff HEAD --binary --ignore-submodules > "$DEST/git/wip/$wid.patch" 2>>"$LOG"
    [ -s "$DEST/git/wip/$wid.patch" ] || rm -f "$DEST/git/wip/$wid.patch"
    ( cd "$wt" && git ls-files -o --exclude-standard -z 2>/dev/null | while IFS= read -r -d '' f; do
        if [[ "$f" =~ $SKIP_RE ]]; then echo "skipped (db dump, other people's data): $wt/$f" >> "$LOG"
        elif [[ "$f" =~ $SECRET_RE ]]; then echo "credential-like, kept out of plain copy: $wt/$f" >> "$LOG"
        elif [ "$(stat -f %z "$f" 2>/dev/null || echo 0)" -gt $MAXFILE ]; then echo "skipped (>200MB): $wt/$f" >> "$LOG"
        else printf '%s\0' "$f"; fi
      done | tar --null -T - -czf "$DEST/git/wip/$wid.untracked.tgz" 2>>"$LOG" )
    [ "$(tar -tzf "$DEST/git/wip/$wid.untracked.tgz" 2>/dev/null | head -1)" ] || rm -f "$DEST/git/wip/$wid.untracked.tgz"
  done

  # Git-ignored env/key files, except in repos that regenerate them from 1Password.
  if ! [[ "$url" =~ $NO_ENV_COPY_RE ]]; then
    while IFS= read -r f; do
      [[ "$f" =~ $SECRET_RE ]] && [[ "$f" != */ ]] && SECRETS+=("$r/$f")
    done < <(git -C "$r" ls-files -o -i --exclude-standard --directory 2>/dev/null | grep -v node_modules)
  fi
  # Untracked (not ignored) credential files are never generated, so always keep them.
  while IFS= read -r f; do [[ "$f" =~ $SECRET_RE ]] && SECRETS+=("$r/$f"); done \
    < <(git -C "$r" ls-files -o --exclude-standard 2>/dev/null)
done <<< "$REPOS"

# ---------------------------------------------------------------------------
bold "2/6  Non-git folders and loose files under ~/code"
LOOSE=()
for p in "$HOME"/code/* "$HOME"/code/.[!.]* "$HOME"/code/plot/* "$HOME"/code/plot/.[!.]*; do
  [ -e "$p" ] || continue
  [ -e "$p/.git" ] && continue
  case "$p" in "$HOME/code/plot"|*-worktrees|*/.repro|*/.DS_Store|*/.cache) continue ;; esac
  LOOSE+=("${p#"$HOME"/}")
done
log "  ${#LOOSE[@]} items: ${LOOSE[*]}"
while IFS= read -r f; do SECRETS+=("$f"); done < <(
  for p in "${LOOSE[@]}"; do find "$HOME/$p" -name node_modules -prune -o -type f -print 2>/dev/null; done | grep -E "$SECRET_RE")
[ $DRY = 0 ] && { tar -C "$HOME" -czf "$DEST/files/code-loose.tgz" "${TAR_EXCLUDES[@]}" "${LOOSE[@]}" 2>>"$LOG" || warn "some ~/code files could not be read (see log)"; }

# ---------------------------------------------------------------------------
bold "3/6  Personal folders and loose files in ~"
for p in "$HOME"/*; do
  name=$(basename "$p")
  case "$HOME_SKIP" in *" $name "*) continue ;; esac
  [ -L "$p" ] && continue
  if [ -f "$p" ]; then
    if [[ "$name" =~ $SECRET_RE ]] || [[ "$name" == *.dump ]]; then SECRETS+=("$p"); continue; fi
  fi
  log "  $(du -sh "$p" 2>/dev/null | cut -f1)	~/$name"
  [ $DRY = 1 ] && continue
  if [ -d "$p" ]; then
    # Keys found in these folders (e.g. Downloads) go to secrets.dmg instead.
    while IFS= read -r f; do SECRETS+=("$f"); done < <(find "$p" -type f 2>/dev/null | grep -E "$SECRET_RE")
    mkdir -p "$DEST/files/home/$name"
    tar -C "$HOME" -cf - "${TAR_EXCLUDES[@]}" --exclude '*.dmg' --exclude '*.pkg' "$name" 2>>"$LOG" \
      | tar -C "$DEST/files/home" -xf - 2>>"$LOG" || warn "some files in ~/$name could not be read (see log)"
  else
    cp -p "$p" "$DEST/files/home/" 2>>"$LOG" || warn "could not copy ~/$name"
  fi
done
[ $DRY = 1 ] && for d in "$HOME"/*/; do d=${d%/}; case "$HOME_SKIP" in *" $(basename "$d") "*) continue ;; esac
  while IFS= read -r f; do SECRETS+=("$f"); done < <(find "$d" -type f 2>/dev/null | grep -E "$SECRET_RE"); done

# ---------------------------------------------------------------------------
bold "4/6  App settings"
CONFIG=(
  .claude/CLAUDE.md .claude/settings.json .claude/settings.local.json .claude/keybindings.json
  .claude/skills .claude/skills.disabled .claude/scripts .claude/commands .claude/agents
  .claude/plugins/installed_plugins.json .claude/plugins/known_marketplaces.json .claude/plugins/config.json
  "Library/Application Support/Alfred"
  "Library/Application Support/obs-studio/basic"
  .config/raycast/config.json .config/raycast/extensions
  .config/git/ignore
  Library/Fonts
)
for f in "$HOME"/Library/LaunchAgents/com.krisbraun.*.plist "$HOME"/Library/LaunchAgents/com.cloudflare.cloudflared.plist; do
  [ -e "$f" ] && CONFIG+=("${f#"$HOME"/}")
done
if [ $TRANSCRIPTS = 1 ]; then CONFIG+=(.claude/projects); else
  for m in "$HOME"/.claude/projects/*/memory; do [ -d "$m" ] && CONFIG+=("${m#"$HOME"/}"); done
fi
for c in "${CONFIG[@]}"; do
  [ -e "$HOME/$c" ] || continue
  log "  ~/$c"
  [ $DRY = 1 ] && continue
  mkdir -p "$DEST/files/config/$(dirname "$c")"
  ditto "$HOME/$c" "$DEST/files/config/$c" 2>>"$LOG" || warn "could not copy ~/$c"
done
warn "Raycast needs a manual export: Raycast Settings > Advanced > Export, save into $DEST"

# ---------------------------------------------------------------------------
bold "5/6  Inventory (reference only)"
if [ $DRY = 0 ]; then
  inv="$DEST/inventory"
  brew bundle dump --file="$inv/Brewfile.current" --force >/dev/null 2>&1
  ls /Applications > "$inv/applications.txt"
  for a in /Applications/*.app; do [ -d "$a/Contents/_MASReceipt" ] && echo "$(mdls -raw -name kMDItemAppStoreAdamID "$a") $(basename "$a" .app)"; done > "$inv/app-store.txt"
  (asdf plugin list --urls; asdf list) > "$inv/asdf.txt" 2>&1
  npm ls -g --depth=0 > "$inv/npm-global.txt" 2>&1
  cargo install --list > "$inv/cargo.txt" 2>&1
  defaults read com.apple.dock persistent-apps > "$inv/dock.plist.txt" 2>&1
  osascript -e 'tell application "System Events" to get the name of every login item' > "$inv/login-items.txt" 2>&1
  launchctl list > "$inv/launchctl.txt" 2>&1
fi
log "  saved"

# ---------------------------------------------------------------------------
bold "6/6  Credentials -> encrypted secrets.dmg"
for s in .ssh .aws .appstoreconnect .cloudflared .netrc .npmrc .boto .sentryclirc .github_pat .nexus-live-tokens \
         .zshrc.local .config/openai.token .config/plot .config/stripe .gemini/.env .terraform.d/credentials.tfrc.json \
         .android/debug.keystore .android/maps.key .android/adbkey .android/adbkey.pub .pgpass .pypirc .gem/credentials \
         .claude.json .zsh_history secure vpn; do
  [ -e "$HOME/$s" ] && SECRETS+=("$HOME/$s")
done
# Unique, existing paths only; drop files inside an already-listed folder and inside built .app bundles.
SECRETS_U=$(printf '%s\n' "${SECRETS[@]}" | sed 's#/$##' | grep -v '\.app/' | sort -u \
  | awk '{ for (i in seen) if (index($0, i "/") == 1) next; seen[$0]=1; print }' \
  | while IFS= read -r f; do [ -e "$f" ] && echo "$f"; done)
log "  $(echo "$SECRETS_U" | grep -c .) items:"
echo "$SECRETS_U" | sed "s#^$HOME/#    ~/#" | tee -a "$LOG" >&2
log "  + code-signing identities exported from the login keychain (Developer ID / Apple Distribution)"

if [ $DRY = 0 ]; then
  while :; do
    read -rs -p "Password for secrets.dmg (save it in 1Password now): " PW; echo
    read -rs -p "Again: " PW2; echo
    [ -n "$PW" ] && [ "$PW" = "$PW2" ] && break
    echo "Passwords empty or different; try again."
  done
  STAGE=$(mktemp -d "${TMPDIR:-/tmp}/prewipe-secrets.XXXXXX")
  mkdir -p "$STAGE/home"
  echo "$SECRETS_U" | while IFS= read -r f; do
    [ -n "$f" ] || continue
    rel=${f#"$HOME"/}
    mkdir -p "$STAGE/home/$(dirname "$rel")"
    ditto "$f" "$STAGE/home/$rel" 2>>"$LOG" || warn "could not copy $f"
  done
  [ -f "$HOME/.zshrc" ] && cp -p "$HOME/.zshrc" "$STAGE/home/.zshrc.prewipe"
  echo "macOS will ask to allow access to each signing key: click 'Allow' for each."
  security export -k "$HOME/Library/Keychains/login.keychain-db" -t identities -f pkcs12 \
    -P "$PW" -o "$STAGE/codesigning-identities.p12" 2>>"$LOG" \
    || warn "keychain export failed; export manually: Keychain Access > My Certificates > select all > Export"
  printf '%s' "$PW" | hdiutil create -quiet -srcfolder "$STAGE" -volname "PreWipe Secrets" \
    -encryption AES-256 -stdinpass -format UDZO "$DEST/secrets.dmg" 2>>"$LOG" \
    && log "  wrote secrets.dmg ($(du -h "$DEST/secrets.dmg" | cut -f1))" \
    || warn "creating secrets.dmg FAILED; nothing encrypted was written"
  rm -rf "$STAGE"; unset PW PW2
fi

# ---------------------------------------------------------------------------
bold "Done"
if [ $DRY = 0 ]; then
  du -sh "$DEST"/* 2>/dev/null | sed "s#$DEST/##" | tee -a "$LOG"
  n=$(grep -c . "$DEST/repos.tsv"); log "repos.tsv: $n repos ($(grep -c '^#' "$DEST/repos.tsv") commented out as inactive >1 year)"
  grep -E '^skipped' "$LOG" | sed 's/^/  /' | head -50
  cat <<EOF

Next:
  1. Save the secrets.dmg password in 1Password.
  2. Export Raycast settings into this folder (Settings > Advanced > Export).
  3. Wait until Google Drive shows everything uploaded (menu bar icon: no pending files),
     then check the folder on drive.google.com from another device.
EOF
fi
