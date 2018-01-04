# Personal dev environment

## Install:
- https://www.iterm2.com/downloads.html
  - iTerm2 menu -> Install Shell Integration
  - iTerm2 menu -> Preferences -> General -> Load preferences from a custom folder or URL = `$HOME/.iterm2`
- https://www.spectacleapp.com/
- https://www.google.com/intl/en/chrome/browser/
- https://slack.com/
- https://simplenote.com/
- https://www.spotify.com/ca-en/download/mac/

## Run:
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    
    brew install fish git stow neovim node
    
    chsh -s `which fish`

    stow fish git iterm2 tmux vim

    curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > dein-install.sh
    sh ./dein-install.sh $HOME/.cache/dein
    rm dein-install.sh
    
    ssh-keygen -t rsa -C "[email]"
    pbcopy < ~/.ssh/id_rsa.pub
    # Add key: https://github.com/settings/ssh
    
    mkdir -p ~/.vim/autoload ~/.vim/bundle && \
        curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
    
    cd ~/.vim/bundle
    git clone https://github.com/vim-scripts/CSApprox
    git clone https://github.com/ap/vim-css-color.git
    git clone https://github.com/tpope/vim-fugitive.git
    git clone https://github.com/hail2u/vim-css3-syntax.git
    git clone https://github.com/groenewege/vim-less
    git clone https://github.com/kchmck/vim-coffee-script.git
    git clone git@github.com:slim-template/vim-slim.git
    git clone git://github.com/tpope/vim-rails.git
    git clone git://github.com/tpope/vim-bundler.git
    git clone https://github.com/scrooloose/nerdtree.git
    cd

## TODO:
- [ ] neovim plugin manager
