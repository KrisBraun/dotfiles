-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Hard-wrap markdown at 80 columns while typing
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("markdown_textwidth", { clear = true }),
  pattern = "markdown",
  callback = function()
    vim.opt_local.textwidth = 80
    vim.opt_local.formatoptions:append("t") -- auto-wrap text at textwidth as you type
    vim.opt_local.formatoptions:append("n") -- recognise numbered lists when reflowing
    vim.opt_local.formatoptions:remove("l") -- also wrap lines that were already long
    vim.opt_local.formatexpr = "" -- gq uses built-in textwidth reflow, not conform/prettier
    vim.opt_local.colorcolumn = "81" -- visual guide
  end,
})
