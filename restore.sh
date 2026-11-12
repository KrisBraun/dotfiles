#!/usr/bin/env bash
# Phase 2 on a fresh Mac (after install.sh): restore what backup.sh saved.
#
#   ~/dotfiles/restore.sh                 # newest folder in Google Drive "My Drive/Mac Backup"
#   ~/dotfiles/restore.sh /path/to/backup # a specific backup folder
#
# Order: credentials -> repos (+ local branches/stashes) -> loose code -> app settings ->
# launch agents -> Claude Code plugins. Safe to re-run: existing repos and files are left alone
# (except app settings, which are overwritten from the backup).
set -uo pipefail

BK="${1:-}"
if [ -z "$BK" ]; then
  BK=$(ls -d "$HOME"/Library/CloudStorage/GoogleDrive-*/"My Drive/Mac Backup"/*/ 2>/dev/null | sort | tail -1)
fi
BK="${BK%/}"
[ -f "$BK/repos.tsv" ] || { echo "No backup found (looked for repos.tsv in '$BK'). Pass the folder path." >&2; exit 1; }

FAILED=""
step() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[33m! %s\033[0m\n' "$*"; FAILED="$FAILED\n  - $*"; }
ask()  { local a; read -r -p "$1 [y/N] " a; [[ "$a" =~ ^[Yy] ]]; }
id_of() { echo "$1" | sed 's#/#__#g'; }

echo "Restoring from: $BK"
echo "(Google Drive downloads each file on first read; the first steps can be slow.)"

# ---------------------------------------------------------------------------
step "1/6  Credentials from secrets.dmg"
MNT=""
if [ -f "$BK/secrets.dmg" ]; then
  MNT=$(mktemp -d /tmp/prewipe-secrets.XXXXXX)
  read -rs -p "secrets.dmg password (from 1Password): " PW; echo
  if printf '%s' "$PW" | hdiutil attach -quiet -nobrowse -readonly -stdinpass -mountpoint "$MNT" "$BK/secrets.dmg"; then
    if [ -e "$HOME/.claude.json" ] && [ -e "$MNT/home/.claude.json" ]; then
      ask "Replace the new ~/.claude.json with the old one (MCP servers, per-project settings)?" \
        && mv "$HOME/.claude.json" "$HOME/.claude.json.fresh"
    fi
    # Everything except repo env files (those go in after the repos are cloned).
    for e in "$MNT"/home/* "$MNT"/home/.[!.]*; do
      [ -e "$e" ] || continue
      name=$(basename "$e")
      [ "$name" = code ] && continue
      [ "$name" = .claude.json ] && [ -e "$HOME/.claude.json" ] && continue
      ditto "$e" "$HOME/$name" || warn "restore ~/$name"
    done
    chmod 700 "$HOME/.ssh" 2>/dev/null
    find "$HOME/.ssh" -type f ! -name '*.pub' ! -name '*.ovpn' ! -name 'known_hosts*' ! -name config -exec chmod 600 {} + 2>/dev/null
    if [ -f "$MNT/codesigning-identities.p12" ]; then
      security import "$MNT/codesigning-identities.p12" -k "$HOME/Library/Keychains/login.keychain-db" \
        -P "$PW" -T /usr/bin/codesign -T /usr/bin/security >/dev/null \
        && echo "Imported code-signing identities." || warn "keychain import (double-click codesigning-identities.p12 in the image instead)"
    fi
    echo "Restored. The old ~/.zshrc is at ~/.zshrc.prewipe for reference."
  else
    warn "could not open secrets.dmg (wrong password?)"; MNT=""
  fi
  unset PW
else
  warn "no secrets.dmg in backup"
fi

# SSH for GitHub: load keys into the agent, else fall back to HTTPS via gh.
for k in "$HOME"/.ssh/id_rsa "$HOME"/.ssh/id_ed25519; do [ -f "$k" ] && ssh-add --apple-use-keychain "$k" 2>/dev/null; done
GIT_HTTPS=()
if ! ssh -o BatchMode=yes -o StrictHostKeyChecking=accept-new -T git@github.com 2>&1 | grep -q 'successfully authenticated'; then
  echo "SSH to GitHub isn't working; cloning over HTTPS with gh instead."
  gh auth status >/dev/null 2>&1 || gh auth login --web --git-protocol https
  gh auth setup-git
  GIT_HTTPS=(-c "url.https://github.com/.insteadOf=git@github.com:")
fi

# ---------------------------------------------------------------------------
step "2/6  Repositories (edit $BK/repos.tsv first to skip some: lines starting with # are skipped)"
while IFS=$'\t' read -r rel url branch; do
  [ -n "$rel" ] || continue
  dest="$HOME/$rel"; bundle="$BK/git/$(id_of "$rel").bundle"
  if [ -e "$dest/.git" ]; then echo "  exists   ~/$rel"; continue; fi
  mkdir -p "$(dirname "$dest")"
  if [ "$url" = "<no-remote>" ]; then
    if [ -f "$bundle" ]; then
      git clone -q "$bundle" "$dest" && git -C "$dest" remote remove origin && echo "  bundle   ~/$rel (no remote: create one with 'gh repo create')" \
        || warn "clone from bundle: ~/$rel"
    else
      warn "~/$rel had no remote and no bundle"
    fi
    continue
  fi
  echo "  clone    ~/$rel"
  git ${GIT_HTTPS[@]+"${GIT_HTTPS[@]}"} clone -q --recurse-submodules "$url" "$dest" </dev/null || { warn "clone $url"; continue; }
  if [ -f "$bundle" ]; then
    # The bundle becomes a remote named pre-wipe: local-only branches arrive as pre-wipe/<branch>
    # (`git switch <branch>` picks them up) and stashes as refs/pre-wipe/stash-N
    # (`git stash apply refs/pre-wipe/stash-0`). Copy the bundle locally so it outlives Drive.
    mkdir -p "$HOME/code/.pre-wipe-bundles" && cp "$bundle" "$HOME/code/.pre-wipe-bundles/"
    lb="$HOME/code/.pre-wipe-bundles/$(basename "$bundle")"
    git -C "$dest" remote add pre-wipe "$lb"
    git -C "$dest" config remote.pre-wipe.fetch '+refs/heads/*:refs/remotes/pre-wipe/*'
    git -C "$dest" config --add remote.pre-wipe.fetch '+refs/pre-wipe/*:refs/pre-wipe/*'
    git -C "$dest" config remote.pre-wipe.tagOpt --no-tags
    git -C "$dest" fetch -q pre-wipe \
      && echo "           + $(git -C "$dest" for-each-ref refs/remotes/pre-wipe | wc -l | tr -d ' ') local branches, $(git -C "$dest" for-each-ref refs/pre-wipe | wc -l | tr -d ' ') stashes" \
      || warn "apply bundle to ~/$rel (kept at $bundle)"
  fi
  if [ -n "$branch" ] && [ "$branch" != "$(git -C "$dest" branch --show-current)" ]; then
    git -C "$dest" switch -q "$branch" 2>/dev/null && echo "           on branch $branch"
  fi
done < <(grep -v '^#' "$BK/repos.tsv")

if [ -n "$MNT" ] && [ -d "$MNT/home/code" ]; then
  echo "  restoring git-ignored env files for non-Plot repos"
  ditto "$MNT/home/code" "$HOME/code" || warn "repo env files"
fi
if [ -d "$BK/git/wip" ] && [ -n "$(ls -A "$BK/git/wip" 2>/dev/null)" ]; then
  mkdir -p "$HOME/code/.pre-wipe-wip" && ditto "$BK/git/wip" "$HOME/code/.pre-wipe-wip"
  echo "  uncommitted work from before the wipe: ~/code/.pre-wipe-wip (git apply <x>.patch; tar xzf <x>.untracked.tgz)"
fi

# ---------------------------------------------------------------------------
step "3/6  Non-git code folders"
[ -f "$BK/files/code-loose.tgz" ] && { tar -xzkf "$BK/files/code-loose.tgz" -C "$HOME" 2>/dev/null; echo "  extracted into ~/code"; }

# ---------------------------------------------------------------------------
step "4/6  App settings (Claude Code config + memory, Alfred, OBS, Raycast, fonts)"
osascript -e 'quit app "Alfred 5"' 2>/dev/null
if [ -d "$BK/files/config" ]; then
  ditto "$BK/files/config" "$HOME" && echo "  done" || warn "app settings"
fi

# ---------------------------------------------------------------------------
step "5/6  Launch agents"
for p in "$HOME"/Library/LaunchAgents/com.krisbraun.*.plist "$HOME"/Library/LaunchAgents/com.cloudflare.cloudflared.plist; do
  [ -f "$p" ] || continue
  label=$(basename "$p" .plist)
  missing=$(plutil -extract ProgramArguments json -o - "$p" 2>/dev/null | jq -r '.[] | select(startswith("/"))' \
            | while read -r a; do [ -e "$a" ] || echo "$a"; done | head -1)
  if [ -n "$missing" ]; then echo "  skip $label ($missing not present)"; continue; fi
  launchctl bootout "gui/$(id -u)/$label" 2>/dev/null
  launchctl bootstrap "gui/$(id -u)" "$p" && echo "  loaded $label" || warn "launch agent $label"
done
brew services start syncthing >/dev/null 2>&1 && echo "  syncthing started (re-pair ~/Notes with the phone at http://127.0.0.1:8384)"

# ---------------------------------------------------------------------------
step "6/6  Claude Code plugins"
CLAUDE="$HOME/.local/bin/claude"
if [ -x "$CLAUDE" ] && [ -f "$HOME/.claude/plugins/known_marketplaces.json" ]; then
  jq -r 'to_entries[] | .value.source.repo // empty' "$HOME/.claude/plugins/known_marketplaces.json" | while read -r repo; do
    "$CLAUDE" plugin marketplace add "$repo" >/dev/null 2>&1 && echo "  marketplace $repo" || warn "marketplace $repo (add with /plugin)"
  done
  jq -r '.plugins | keys[]' "$HOME/.claude/plugins/installed_plugins.json" 2>/dev/null | while read -r pl; do
    "$CLAUDE" plugin install "$pl" >/dev/null 2>&1 && echo "  plugin $pl" || warn "plugin $pl (install with /plugin)"
  done
fi

[ -n "$MNT" ] && hdiutil detach -quiet "$MNT"

# ---------------------------------------------------------------------------
printf '\n\033[1;32mPhase 2 done.\033[0m\n'
[ -n "$FAILED" ] && printf '\033[33mThese need another look:%b\033[0m\n' "$FAILED"
cat <<EOF

Personal files (Downloads, Movies, Pictures, notes-vault copies, diagnostics) stayed in:
  $BK/files/home
Copy back only what you want.

By hand:
  - Raycast: Settings > Advanced > Import the .rayconfig saved in the backup folder.
  - Plot repos, in each of dispatch / nexus / pulse / traction / incite:
        pnpm install && pnpm get-env        (env + signing files come from 1Password)
  - Logins: gh auth login, gcloud auth login && gcloud auth application-default login,
            aws sso login --profile runQL, az login, wrangler login, stripe login, op signin,
            docker login, firebase/shorebird login as needed.
  - Android Studio: install SDK + platform-tools.   Xcode: open once, accept licence, add Apple ID.
  - Obsidian: open ~/Notes as a vault.   1Password: turn on SSH agent / CLI integration if you use it.
  - Local-only branches: in a restored repo, 'git branch -r | grep pre-wipe' lists them.
EOF
