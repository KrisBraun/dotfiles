# Personal dev environment

## Run:
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew install fish git stow neovim node python3 fzf the_silver_searcher
    brew install --HEAD universal-ctags/universal-ctags/universal-ctags
    pip3 install neovim

    git clone https://github.com/ryanoasis/nerd-fonts
    cd nerd-fonts/
    fontforge -script font-patcher --complete --progressbars --extension dfont /System/Library/Fonts/Monaco.dfont
    sudo cp Monaco\ Nerd\ Font\ Complete.dfont /Library/Fonts/
    
    chsh -s `which fish`

    stow fish git iterm2 tmux vim

    curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > dein-install.sh
    sh ./dein-install.sh $HOME/.cache/dein
    rm dein-install.sh
    
    ssh-keygen -t rsa -C "[email]"
    pbcopy < ~/.ssh/id_rsa.pub
    # Add key: https://github.com/settings/ssh

## Install:
- https://www.iterm2.com/downloads.html
  - iTerm2 menu -> Install Shell Integration
  - iTerm2 menu -> Preferences -> General -> Load preferences from a custom folder or URL = `$HOME/.iterm2`
- https://www.spectacleapp.com/
- https://www.google.com/intl/en/chrome/browser/
- https://slack.com/
- https://simplenote.com/
- https://www.spotify.com/ca-en/download/mac/
- https://itunes.apple.com/us/app/irvue/id1039633667?mt=12
