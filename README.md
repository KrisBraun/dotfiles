# Personal dev environment

## Install:
- https://www.iterm2.com/downloads.html
- https://www.spectacleapp.com/
- https://www.google.com/intl/en/chrome/browser/
- https://slack.com/
- https://simplenote.com/
- https://www.spotify.com/ca-en/download/mac/

## Run:
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    
    brew install fish
    
    chsh -s `which fish`
    
    ssh-keygen -t rsa -C "[email]"
    xclip -sel clip < ~/.ssh/id_rsa.pub
    # Add key: https://github.com/settings/ssh
    
    git clone git://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
    printf '\nsource "$HOME/.homesick/repos/homeshick/homeshick.sh"' >> $HOME/.bashrc
    source $HOME/.bashrc
    homeshick clone git@github.com:KrisBraun/dotfiles.git
    homeshick symlink dotfiles

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
