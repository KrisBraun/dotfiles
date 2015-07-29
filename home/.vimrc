set nocompatible

filetype off                    " force reloading *after* pathogen loaded
call pathogen#infect()
call pathogen#helptags()
filetype plugin indent on       " enable detection, plugins and indenting in one step
syntax on

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
set clipboard=unnamedplus
set mouse=a
set t_Co=256

set background=dark
colorscheme evening

nmap <TAB> :bn
nmap <S-TAB> :bN
map ; :

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
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

map <C-n> :NERDTreeToggle<CR>
