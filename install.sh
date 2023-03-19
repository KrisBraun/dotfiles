#!/bin/sh

# Homebrew
UNAME_MACHINE="$(/usr/bin/uname -m)"
if [[ "${UNAME_MACHINE}" == "arm64" ]]
then
  HOMEBREW_PREFIX="/opt/homebrew"
else
  HOMEBREW_PREFIX="/usr/local"
fi
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# git and clone this repo
$HOMEBREW_PREFIX/brew install git
git -C ~ clone https://github.com/KrisBraun/dotfiles.git

# Install all brew
$HOMEBREW_PREFIX/brew bundle install --file ~/dotfiles/Brewfile

# NVIM Packer
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Fisher
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher

# Node
npm install -g typescript typescript-language-server

# Python
pip3 install neovim
