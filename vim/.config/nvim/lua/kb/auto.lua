" autocmd BufEnter * set cursorline
" autocmd BufLeave * set nocursorline
autocmd BufEnter * hi CursorLine guibg=#1d2021 gui=none
autocmd FileType php setlocal shiftwidth=4 tabstop=4

augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END

" autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue Prettier
