# Personal dev environment

## Install:
- App Store
  - 1password
  - Todoist
  - SimpleNote
- https://fontforge.org/en-US/downloads/
- https://www.iterm2.com/downloads.html
  - iTerm2 menu -> Install Shell Integration
  - iTerm2 menu -> Preferences -> General -> Load preferences from a custom folder or URL = `$HOME/.iterm2`
- https://www.google.com/intl/en/chrome/browser/
- https://rectangleapp.com/
- https://slack.com/
- https://www.spotify.com/ca-en/download/mac/
- https://itunes.apple.com/us/app/irvue/id1039633667?mt=12

## Run:
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew install fish git stow neovim node python3 fzf the_silver_searcher
    brew install --HEAD universal-ctags/universal-ctags/universal-ctags
    pip3 install neovim

    brew tap homebrew/cask-fonts
    brew cask install font-inconsolata-nerd-font
    
    sudo echo /usr/local/bin/fish >> /etc/shells
    chsh -s `which fish`

    stow fish git iterm2 tmux vim

    git config --global core.excludesfile ~/.gitignore_global

    curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > dein-install.sh
    sh ./dein-install.sh $HOME/.cache/dein
    rm dein-install.sh
    
    ssh-keygen -t rsa -C "[email]"
    pbcopy < ~/.ssh/id_rsa.pub
    # Add key: https://github.com/settings/ssh
