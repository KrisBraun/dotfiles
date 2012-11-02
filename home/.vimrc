set nocompatible
set expandtab
set shiftwidth=2
set tabstop=8
set shiftround
set shiftwidth=2
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

call pathogen#infect() 

colorscheme evening

nmap <TAB> :bn
nmap <S-TAB> :bN

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
