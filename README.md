dotfiles
========

Personal dev environment

    git clone git://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
    printf '\nalias homeshick="$HOME/.homesick/repos/homeshick/home/.homeshick"' >> $HOME/.bashrc
    source $HOME/.bashrc

    apt-get install zsh tmux vim exuberant-ctags

    wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh

    mkdir -p ~/.vim/autoload ~/.vim/bundle; \
    curl -Sso ~/.vim/autoload/pathogen.vim \
        https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

    cd ~/.vim/bundle
    git clone https://github.com/vim-scripts/CSApprox
    git clone https://github.com/ap/vim-css-color.git
    git clone https://github.com/tpope/vim-fugitive.git
    git clone https://github.com/hail2u/vim-css3-syntax.git
    git clone https://github.com/groenewege/vim-less
    git clone https://github.com/kchmck/vim-coffee-script.git
    cd
