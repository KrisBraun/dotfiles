#!/bin/sh

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew bundle install --file ~/dotfiles/Brewfile

# NVIM Packer
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Fisher
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher

# Node
npm install -g typescript typescript-language-server

# Python
pip3 install neovim
