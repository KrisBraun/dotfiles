-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("kb.plugins")

require('onedark').setup {
  style = 'warm',
}
require('onedark').load()
-- vim.cmd.colorscheme "catppuccin"

require('kb.options')
require('kb.auto')
require('kb.treesitter')
require('kb.lsp')
require('kb.map')

-- See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
