set nocompatible

set shell=/bin/bash

let g:syntastic_typescript_checkers = ['tsuquyomi']
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

filetype off                    " force reloading *after* pathogen loaded
call pathogen#infect()
call pathogen#helptags()
filetype plugin indent on       " enable detection, plugins and indenting in one step
syntax on

autocmd BufNewFile,BufRead *.skim setf slim

set runtimepath^=~/.vim/bundle/ctrlp.vim

set dir=$HOME/.vim/swap
if !isdirectory(&dir) | call mkdir(&dir, 'p', 0700) | endif

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

nmap <F8> :TagbarToggle<CR>

let g:tagbar_type_scala = {
    \ 'ctagstype' : 'Scala',
    \ 'kinds'     : [
        \ 'p:packages:1',
        \ 'V:values',
        \ 'v:variables',
        \ 'T:types',
        \ 't:traits',
        \ 'o:objects',
        \ 'a:aclasses',
        \ 'c:classes',
        \ 'r:cclasses',
        \ 'm:methods'
    \ ]
\ }

cabbr <expr> %% expand('%:p:h')

au BufRead,BufNewFile *.skim setfiletype slim
runtime macros/matchit.vim

autocmd StdinReadPre * let s:std_in=1

map <C-n> :NERDTreeToggle<CR>

set cursorline
hi Normal cterm=none ctermbg=235
hi CursorLine cterm=none ctermbg=233
hi MatchParen cterm=reverse ctermbg=black ctermfg=110
set backspace=2

set wildignore+=*/vendor/*,*.swp,*/public/*,*/tmp/*

cabbr <expr> %% expand('%:p:h')
