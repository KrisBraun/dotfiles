#!/bin/sh
# Snapshot what's installed now, to compare against the curated Brewfile:
#   diff <(grep -E '^(brew|cask|mas)' ~/dotfiles/Brewfile | sort) <(sort ~/dotfiles/Brewfile.current)
brew bundle dump --force --file ~/dotfiles/Brewfile.current
cp ~/.tool-versions ~/dotfiles/asdf/.tool-versions 2>/dev/null || true
echo "Wrote ~/dotfiles/Brewfile.current (not committed). Copy new lines into Brewfile by hand."
