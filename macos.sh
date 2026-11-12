#!/bin/bash
# macOS settings. The previous Mac ran almost entirely on macOS defaults, so this only
# rebuilds the Dock. Optional tweaks are below, commented out.

# Dock: same apps, same order as before the wipe (skips any app that isn't installed).
if command -v dockutil >/dev/null; then
  dockutil --remove all --no-restart >/dev/null
  for app in "Zen" "Zen Browser" "Microsoft Edge" "kitty" "Linear" "Obsidian" "Superlist" "1Password" \
             "HTTPie" "Beeper" "Discord" "Slack"; do
    [ -d "/Applications/$app.app" ] && dockutil --add "/Applications/$app.app" --no-restart >/dev/null
  done
  killall Dock
fi

# --- Optional (from the old config.sh) ---
# Screenshots into ~/Documents/Screenshots instead of the Desktop:
#   mkdir -p ~/Documents/Screenshots && defaults write com.apple.screencapture location ~/Documents/Screenshots
# Disable the over-sensitive two-finger back-swipe in Chrome:
#   defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
