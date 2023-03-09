#!/bin/sh

if [ -z "$1" ] 
  then
    echo "Missing email address as first argument"
    exit 1
fi

stow -d ~/dotfiles mackup.cfg fish git nvim kitty

mackup restore

# Fish as default shell
sudo sh -c 'echo `which fish` >> /etc/shells'
chsh -s `which fish`

# SSH
ssh-keygen -t rsa -C "$1"
pbcopy < ~/.ssh/id_rsa.pub
echo "Paste key at https://github.com/settings/ssh"

# Git
git config --global user.email "$1"
git config --global user.name "Kris Braun"
git config --global core.excludesfile ~/.gitignore_global
git config --global push.default current

# Default screenshot folder
mkdir -p $HOME/Documents/Screenshots
defaults write com.apple.screencapture location $HOME/Documents/Screenshots

# Disable the all too sensitive backswipe on trackpads
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false
