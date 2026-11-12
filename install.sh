#!/bin/bash
# Phase 1 on a fresh Mac: command-line tools, Homebrew, apps, shell, dotfiles, language runtimes.
#
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/KrisBraun/dotfiles/master/install.sh)"
#
# Safe to re-run: every step skips what is already done. Then run ~/dotfiles/restore.sh (phase 2).
set -uo pipefail

DOT="$HOME/dotfiles"
STOW_PACKAGES="zsh git kitty nvim karabiner zed asdf mackup.cfg"
FAILED=""

step() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[33m! %s\033[0m\n' "$*"; FAILED="$FAILED\n  - $*"; }
clone_if_missing() { [ -d "$2" ] || git clone --depth=1 "$1" "$2" || warn "clone $1"; }

# Ask for the password once, then keep sudo alive for the whole run (Homebrew and casks need it).
sudo -v
( while true; do sudo -n true; sleep 50; kill -0 "$$" 2>/dev/null || exit; done ) 2>/dev/null &

step "Xcode Command Line Tools"
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install
  echo "Finish the Command Line Tools dialog, then press Enter."; read -r _
fi

step "Rosetta (for the occasional Intel-only app)"
/usr/bin/pgrep -q oahd || softwareupdate --install-rosetta --agree-to-license || warn "Rosetta"

step "Homebrew"
if ! [ -x /opt/homebrew/bin/brew ]; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

step "dotfiles"
[ -d "$DOT/.git" ] || git clone https://github.com/KrisBraun/dotfiles.git "$DOT"

step "Homebrew taps (trusted) + Brewfile (takes a while)"
for t in $(sed -nE 's/^tap "([^"]+)".*/\1/p' "$DOT/Brewfile"); do
  { brew tap "$t" && brew trust "$t" >/dev/null; } || warn "tap $t"
done
echo "Sign in to the App Store app now if you want the App Store apps (Xcode etc.), then press Enter."
read -r _
brew bundle install --file "$DOT/Brewfile" || warn "some Brewfile entries failed: re-run 'brew bundle --file ~/dotfiles/Brewfile'"

step "Oh My Zsh, Powerlevel10k, zsh plugins"
[ -d "$HOME/.oh-my-zsh" ] || RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
ZC="$HOME/.oh-my-zsh/custom"
clone_if_missing https://github.com/romkatv/powerlevel10k.git "$ZC/themes/powerlevel10k"
clone_if_missing https://github.com/zsh-users/zsh-autosuggestions "$ZC/plugins/zsh-autosuggestions"
clone_if_missing https://github.com/zsh-users/zsh-completions "$ZC/plugins/zsh-completions"
clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting "$ZC/plugins/zsh-syntax-highlighting"

step "Link dotfiles with stow"
for f in .zshrc .zprofile .zshenv .p10k.zsh .gitconfig .gitignore_global .tool-versions .asdfrc .mackup.cfg; do
  if [ -e "$HOME/$f" ] && [ ! -L "$HOME/$f" ]; then mv "$HOME/$f" "$HOME/$f.pre-dotfiles"; fi
done
mkdir -p "$HOME/.config"
# shellcheck disable=SC2086
stow -d "$DOT" -t "$HOME" $STOW_PACKAGES || warn "stow (a file is in the way; move it and re-run)"
# Amethyst + keyboard-shortcut prefs. macOS no longer honours symlinked prefs, so copy them.
cp "$DOT"/mackup/Library/Preferences/*.plist "$HOME/Library/Preferences/" && killall cfprefsd 2>/dev/null

step "asdf plugins + versions from ~/.tool-versions (python/ruby compile: slow)"
asdf_plugin() { asdf plugin list 2>/dev/null | grep -qx "$1" || asdf plugin add "$1" "$2" || warn "asdf plugin $1"; }
asdf_plugin nodejs    https://github.com/asdf-vm/asdf-nodejs.git
asdf_plugin pnpm      https://github.com/jonathanmorley/asdf-pnpm.git
asdf_plugin python    https://github.com/danhper/asdf-python.git
asdf_plugin ruby      https://github.com/asdf-vm/asdf-ruby.git
asdf_plugin java      https://github.com/halcyon/asdf-java.git
asdf_plugin golang    https://github.com/asdf-community/asdf-golang.git
asdf_plugin neovim    https://github.com/richin13/asdf-neovim.git
asdf_plugin dart      https://github.com/PatOConnor43/asdf-dart.git
asdf_plugin flutter   https://github.com/oae/asdf-flutter.git
asdf_plugin terraform https://github.com/asdf-community/asdf-hashicorp.git
asdf_plugin yarn      https://github.com/twuni/asdf-yarn.git
(cd "$HOME" && asdf install) || warn "asdf install (re-run: cd ~ && asdf install)"
export PATH="$HOME/.asdf/shims:$PATH"

step "Global tools"
mkdir -p "$HOME/.npm-global" && npm config set prefix "$HOME/.npm-global"
npm install -g @google/gemini-cli @pgkit/migrator mcp-hub || warn "npm globals"
uv tool install aider-chat || warn "aider"
if ! [ -x "$HOME/.cargo/bin/cargo" ]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path || warn "rustup"
fi
"$HOME/.cargo/bin/cargo" install cargo-watch cargo-nextest || warn "cargo tools"
dart pub global activate derry >/dev/null || warn "derry"
[ -d "$HOME/.shorebird" ] || curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/shorebirdtech/install/main/install.sh | bash || warn "shorebird"
[ -x "$HOME/.opencode/bin/opencode" ] || curl -fsSL https://opencode.ai/install | bash || warn "opencode"

step "Claude Code"
[ -x "$HOME/.local/bin/claude" ] || curl -fsSL https://claude.ai/install.sh | bash || warn "Claude Code"

step "macOS settings"
bash "$DOT/macos.sh" || warn "macos.sh"

printf '\n\033[1;32mPhase 1 done.\033[0m\n'
[ -n "$FAILED" ] && printf '\033[33mThese steps need another look:%b\033[0m\n' "$FAILED"
cat <<'EOF'

Next:
  1. Open a new terminal tab (zsh + Powerlevel10k should load).
  2. Sign in: 1Password, Google Drive, Chrome, Zen (Firefox Sync), Raycast, Slack, etc.
  3. When Google Drive shows "My Drive/Mac Backup", run:   ~/dotfiles/restore.sh
EOF
