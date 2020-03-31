# Personal dev environment

## Install:
- App Store
  - 1password
  - Slack
  - Todoist
  - SimpleNote
  - Irvue
- https://www.google.com/intl/en/chrome/browser/
- https://rectangleapp.com/
  - Set Preferences -> Settings -> Launch on login
- https://www.iterm2.com/downloads.html
  - iTerm2 menu -> Install Shell Integration
  - iTerm2 menu -> Preferences -> General -> Load preferences from a custom folder or URL = `$HOME/.iterm2`
- https://www.spotify.com/ca-en/download/mac/

## Run:
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    brew install fish git stow neovim node python3 fzf the_silver_searcher
    brew install --HEAD universal-ctags/universal-ctags/universal-ctags
    pip3 install neovim
    
    ssh-keygen -t rsa -C "[email]"
    pbcopy < ~/.ssh/id_rsa.pub
    # Add key: https://github.com/settings/ssh

    git clone git@github.com:KrisBraun/dotfiles.git
    cd dotfiles
    stow fish git iterm2 tmux vim ctags
    cd

    brew tap homebrew/cask-fonts
    brew cask install font-inconsolata-nerd-font
    
    sudo sh -c 'echo `which fish` >> /etc/shells'
    chsh -s `which fish`

    curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher

    git config --global core.excludesfile ~/.gitignore_global

    curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > dein-install.sh
    sh ./dein-install.sh $HOME/.cache/dein
    rm dein-install.sh
