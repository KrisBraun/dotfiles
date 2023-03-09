#!/bin/sh

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# git and clone this repo
brew install git
git -C ~ clone git@github.com:KrisBraun/dotfiles.git

# Install all brew
brew bundle install --file ~/dotfiles/Brewfile

# NVIM Packer
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Fisher
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher

# Node
npm install -g typescript typescript-language-server

# Python
pip3 install neovim
