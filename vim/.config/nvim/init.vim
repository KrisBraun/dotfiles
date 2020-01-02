if &compatible
  set nocompatible               " Be iMproved
endif

set shell=/bin/bash

let g:python3_host_prog = '/usr/local/bin/python3'
let g:python_host_prog = '/usr/local/bin/python'

let g:airline_theme='gruvbox'
let g:airline_powerline_fonts = 1
" let g:airline#extensions#syntastic#enabled = 1
" let g:syntastic_always_populate_loc_list = 0
" let g:syntastic_auto_loc_list = 0
" let g:syntastic_check_on_open = 0
" let g:syntastic_check_on_wq = 0
" let g:syntastic_javascript_checkers = ['javascript/eslint']
let g:deoplete#enable_at_startup = 1
let g:jsx_ext_required = 0

let $FZF_DEFAULT_COMMAND = 'fd --type f'

set runtimepath+=$HOME/.cache/dein/repos/github.com/Shougo/dein.vim
if dein#load_state('$HOME/.cache/dein')
  call dein#begin('$HOME/.cache/dein')
  call dein#add('$HOME/.cache/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here:
  call dein#add('/usr/local/opt/fzf')
  call dein#add('junegunn/fzf.vim')
  call dein#add('pangloss/vim-javascript')
  call dein#add('mxw/vim-jsx')
  call dein#add('ludovicchabant/vim-gutentags')
  call dein#add('Shougo/deoplete.nvim')
  " call dein#add('vim-syntastic/syntastic')
  call dein#add('ap/vim-css-color.git')
  call dein#add('tpope/vim-fugitive.git')
  call dein#add('idanarye/vim-merginal')
  call dein#add('tpope/vim-commentary.git')
  call dein#add('ryanoasis/vim-devicons')
  call dein#add('sheerun/vim-polyglot')
  call dein#add('morhetz/gruvbox')
  call dein#add('tpope/vim-unimpaired')
  call dein#add('vim-airline/vim-airline')
  call dein#add('tpope/vim-surround')
  call dein#add('prettier/vim-prettier')
  call dein#add('w0rp/ale')

  call dein#add('HerringtonDarkholme/yats')
  call dein#add('maxmellon/vim-jsx-pretty')

  call dein#end()
  call dein#save_state()

  autocmd BufEnter * hi CursorLine guibg=#1d2021 gui=none
endif

filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

set t_Co=256
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
set wildignorecase
if has("unnamedplus")
  set clipboard=unnamedplus
else
  set clipboard=unnamed
endif
set mouse=a

set completeopt+=noinsert

nmap <TAB> :bn
nmap <S-TAB> :bN
nmap <C-TAB> :cnext
map ; :

nnoremap <silent> <c-p> :GFiles<CR>
nnoremap <silent> <c-s> "zyiw:exe "Ag ".@z.""<CR>

set backspace=2
set encoding=utf8

set wildignore+=*/vendor/*,*.swp,*/public/*,*/tmp/*

set undofile

set background=dark

" Load local config
set exrc
set secure

hi Visual guibg=#1d2021 gui=none
set guicursor=n-v-c:hor20,i-ci:ver25,r-cr:hor20

" autocmd BufEnter * set cursorline
" autocmd BufLeave * set nocursorline

augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END

" autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue Prettier

let g:gutentags_ctags_extra_args = ['-G']
