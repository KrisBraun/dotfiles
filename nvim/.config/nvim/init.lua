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

require('kb.options')
require('kb.map')
require('kb.auto')
require('kb.treesitter')

-- if next(vim.fn.argv()) == nil then
--   vim.cmd([[
--     augroup startup
--       autocmd!
--       autocmd VimEnter * Telescope oldfiles
--     augroup end
--   ]])
-- end

-- See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
