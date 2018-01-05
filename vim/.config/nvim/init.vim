if &compatible
  set nocompatible               " Be iMproved
endif

set shell=/bin/bash

let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1
let g:airline_theme='oceanicnext'
let g:airline_powerline_fonts = 1
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

set runtimepath+=$HOME/.cache/dein/repos/github.com/Shougo/dein.vim
if dein#load_state('$HOME/.cache/dein')
  call dein#begin('$HOME/.cache/dein')
  call dein#add('$HOME/.cache/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here:
  call dein#add('ctrlpvim/ctrlp.vim')
  call dein#add('ap/vim-css-color.git')
  call dein#add('tpope/vim-fugitive.git')
  call dein#add('tpope/vim-commentary.git')
  call dein#add('vim-airline/vim-airline')
  call dein#add('mhartington/oceanic-next')
  call dein#add('ryanoasis/vim-devicons')
  call dein#add('sheerun/vim-polyglot')
  call dein#add('morhetz/gruvbox')

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

if (has("termguicolors"))
 set termguicolors
endif

" colorscheme OceanicNext
colorscheme gruvbox

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
set encoding=utf8

set wildignore+=*/vendor/*,*.swp,*/public/*,*/tmp/*

set background=dark
