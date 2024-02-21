vim.keymap.set('n', '<TAB>', ':bn<cr>')
vim.keymap.set('n', '<S-TAB>', ':bN<cr>')
vim.keymap.set('n', '<C-TAB>', ':cnext<cr>')
vim.keymap.set('n', ';', ':')

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Subversive (replace with paste)
vim.keymap.set('n', 's', '<plug>(SubversiveSubstitute)')
vim.keymap.set('x', 's', '<plug>(SubversiveSubstitute)')
vim.keymap.set('n', 'ss', '<plug>(SubversiveSubstituteLine)')
vim.keymap.set('n', 'S', '<plug>(SubversiveSubstituteToEndOfLine)')

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>b', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader><tab>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>so', require('telescope.builtin').oldfiles, { desc = '[S]earch [O]ldfiles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sb', require('telescope.builtin').git_branches, { desc = '[S]earch Git [B]ranches' })
vim.keymap.set('n', '<leader>sc', ':Easypick changed_files<cr>', { desc = '[S]earch [C]hanged Git Files' })
vim.keymap.set('n', '<leader>ss', require('telescope.builtin').lsp_document_symbols,
  { desc = '[S]earch Workspace [S]ymbols' })
vim.keymap.set('n', '<leader>sr', ':Telescope resume<cr>')

vim.keymap.set('n', '<leader>g', ':LazyGit<CR>')
vim.keymap.set('n', '<leader>d', ':Gdiffsplit<CR>')

vim.keymap.set('v', '<leader>de', ':!node -e "console.log(decodeURIComponent(process.argv[1]))" -- `cat`<cr>')
vim.keymap.set('v', '<leader>en', ':!node -e "console.log(encodeURIComponent(process.argv[1]))" -- `cat`<cr>')
vim.keymap.set('v', '<leader>jp', ':!json_pp<cr>')
vim.keymap.set('n', '<leader>jp', ':%!json_pp<cr>')

vim.keymap.set('n', '<leader>ws', ':split<cr>')
vim.keymap.set('n', '<leader>wv', ':vsplit<cr>')
vim.keymap.set('n', '<leader>wc', ':close<cr>')
