-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  modules = {},
  auto_install = true,
  sync_install = true,
  ignore_install = {},
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {},

  highlight = { enable = true, use_languagetree = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<leader><space>",
      node_incremental = "<tab>",
      node_decremental = "<s-tab>",
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
      },
      goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
      },
      goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
      },
      goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
            ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
            ['<leader>A'] = '@parameter.inner',
      },
    },
  },
  autotag = {
    enable = true,
    filetypes = {
      'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx',
      'rescript', 'css', 'lua', 'xml', 'php', 'markdown'
    },
  },
}

vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldenable = false
