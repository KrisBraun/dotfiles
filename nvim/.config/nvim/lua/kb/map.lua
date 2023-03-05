vim.keymap.set('n', '<TAB>', ':bn<cr>')
vim.keymap.set('n', '<S-TAB>', ':bN<cr>')
vim.keymap.set('n', '<C-TAB>', ':cnext<cr>')
vim.keymap.set('n', ';', ':')

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Subversive (replace with paste)
vim.keymap.set('n', 's', '<plug>(SubversiveSubstitute)')
vim.keymap.set('x', 's', '<plug>(SubversiveSubstitute)')
