if &compatible
  set nocompatible               " Be iMproved
endif

set shell=/bin/bash

set runtimepath+=$HOME/.cache/dein/repos/github.com/Shougo/dein.vim
if dein#load_state('$HOME/.cache/dein')
  call dein#begin('$HOME/.cache/dein')

  " Let dein manage dein
  " Required:
  call dein#add('$HOME/.cache/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here:
  call dein#add('ctrlpvim/ctrlp.vim')

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

set path=.,**
set expandtab
set shiftround
set tabstop=2
set shiftwidth=2
autocmd FileType php setlocal shiftwidth=4 tabstop=4

set smarttab
set autoindent
set smartindent
set incsearch
set hlsearch
set hidden
set ignorecase
set smartcase
if has("unnamedplus")
  set clipboard=unnamedplus
else
  set clipboard=unnamed
endif
set mouse=a
set t_Co=256

set background=dark
colorscheme evening

nmap <TAB> :bn
nmap <S-TAB> :bN
nmap <C-TAB> :cnext
map ; :
map <C-S> :execute "vimgrep /" . expand("<cword>") . "/ **" <Bar> cw<CR>

set cursorline
hi Normal cterm=none ctermbg=235
hi CursorLine cterm=none ctermbg=233
hi MatchParen cterm=reverse ctermbg=black ctermfg=110
set backspace=2

set wildignore+=*/vendor/*,*.swp,*/public/*,*/tmp/*

let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
