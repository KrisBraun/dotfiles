vim.cmd([[
  augroup ruby_freeze_string_literals
    autocmd!
    autocmd BufNewFile *.rb 0norm A# frozen_string_literal: true
  augroup end
]])

vim.cmd([[
  augroup fmt
    autocmd!
    au BufWritePre * try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry
  augroup END
]])
