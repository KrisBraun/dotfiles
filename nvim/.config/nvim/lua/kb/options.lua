vim.opt.shell = '/bin/bash'

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set colorscheme
if vim.fn.has('termguicolors') == 1 then
  vim.opt.termguicolors = true
end

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

vim.opt.path = '.,**'

vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.textwidth = 80
-- vim.opt.wrap = false
vim.opt.formatoptions = vim.opt.formatoptions + 'tcq'

vim.opt.incsearch = true
vim.opt.hidden = true
vim.opt.wildignorecase = true

if vim.fn.has('unnamedplus') == 1 then
  vim.opt.clipboard = 'unnamedplus'
else
  vim.opt.clipboard = 'unnamed'
end

vim.opt.completeopt:append({ noinsert = true })

-- vim.opt.backspace = 2
vim.opt.encoding = 'utf8'

-- vim.opt.wildignore+=*/vendor/*,*.swp,*/public/*,*/tmp/*

vim.opt.background = 'dark'

-- Load local config
vim.opt.exrc = true
vim.opt.secure = true

vim.opt.guicursor = 'n-v-c:hor20,i-ci:ver25,r-cr:hor20'

vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'

vim.cmd([[highlight Search guibg=guibg guifg=guifg gui=bold,underline]])

vim.g.tagalong_additional_filetypes = { 'javascript' }
vim.g.sql_type_default = 'pgsql'

vim.g.vim_ai_chat = {
  options = {
    model = 'gpt-4o',
  }
}

-- vim.g.neoformat_try_node_exe = true
-- vim.g.neoformat_run_all_formatters = 1
