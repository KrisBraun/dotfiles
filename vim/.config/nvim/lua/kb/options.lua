vim.opt.shell = '/bin/bash'

vim.g.mapleader = ','

vim.go.python3_host_prog = '/usr/local/bin/python3'

vim.go.airline_theme = 'sonokai'
vim.go.airline_powerline_fonts = 1

vim.go.jsx_ext_required = 0

-- filetype plugin indent on
-- syntax enable

--vim.opt.t_Co = 256
if vim.fn.has('termguicolors') == 1 then
 vim.opt.termguicolors = true
end

vim.go.sonokai_style = 'shusia'

vim.opt.path = '.,**'
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.hidden = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildignorecase = true
if vim.fn.has('unnamedplus') == 1 then
  vim.opt.clipboard = 'unnamedplus'
else
  vim.opt.clipboard = 'unnamed'
end
vim.opt.mouse = 'a'

vim.opt.completeopt:append({noinsert = true})

-- vim.opt.backspace = 2
vim.opt.encoding = 'utf8'

-- vim.opt.wildignore+=*/vendor/*,*.swp,*/public/*,*/tmp/*

vim.opt.undofile = true

vim.opt.background = 'dark'

-- Load local config
vim.opt.exrc = true
vim.opt.secure = true

-- hi Visual guibg=#1d2021 gui=none
vim.opt.guicursor = 'n-v-c:hor20,i-ci:ver25,r-cr:hor20'

-- vim.go.gutentags_ctags_extra_args = ['-G']
