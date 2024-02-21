return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
    }
  },

  'lifepillar/pgsql.vim',

  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp"
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip', 'petertriho/cmp-git',
      'hrsh7th/cmp-path' },
  },
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = "master",
    commit = "f2778bd1a28b74adf5b1aa51aa57da85adfa3d16",
    build = ':TSUpdate',
  },

  {
    -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = "master",
    commit = "35a60f093fa15a303874975f963428a5cd24e4a0",
    dependencies = { 'nvim-treesitter' },
  },

  {
    'nvim-tree/nvim-web-devicons',
  },

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  {
    'lewis6991/gitsigns.nvim',
    -- Gitsigns
    -- See `:help gitsigns.txt`
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  {
    "kdheepak/lazygit.nvim",
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  'navarasu/onedark.nvim',
  'rebelot/kanagawa.nvim',

  {
    'nvim-lualine/lualine.nvim', -- Fancier statusline
    opts = {
      sections = {
        lualine_a = { { 'filename', path = 1 } },
        lualine_b = { 'location', 'progress' },
        lualine_c = { 'searchcount' },
        lualine_y = { 'diff' },
        lualine_z = { 'branch' },
      },
    },
  },

  -- Add indentation guides even on blank lines
  {
    'lukas-reineke/indent-blankline.nvim',
  },

  {
    'numToStr/Comment.nvim',
    opts = {},
    lazy = false,
  },

  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  'farmergreg/vim-lastplace',
  'tpope/vim-unimpaired',
  'tpope/vim-surround',
  'tpope/vim-eunuch',
  -- use 'AndrewRadev/tagalong.vim'
  'svermeulen/vim-subversive',
  'nvim-lua/plenary.nvim',

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      pickers = {
        git_branches = {
          initial_mode = "normal",
        },
        oldfiles = {
          initial_mode = "normal",
        },
      }
    }
  },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = vim.fn.executable 'make' ==
        1
  },

  {
    "windwp/nvim-autopairs", -- auto close sybmols
    config = function()
      local Rule = require('nvim-autopairs.rule')
      local npairs = require('nvim-autopairs')
      npairs.setup({
        map_cr = true,   -- send closing symbol to its own line
        check_ts = true, -- use treesitter
      })
      npairs.add_rule(Rule("`", "`", { "typescript", "typescriptreact" }))
    end
  },

  {
    'axkirillov/easypick.nvim',
    requires = 'nvim-telescope/telescope.nvim',
    config = function()
      local easypick = require("easypick")
      easypick.setup({
        pickers = {
          {
            name = "changed_files",
            command = "git status --short | cut -c4-",
            previewer = easypick.previewers.file_diff()
          },
        }
      })
    end,
  },

  'windwp/nvim-ts-autotag',
  {
    "mfussenegger/nvim-lint",
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      }
    end
  },

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        -- Customize or remove this keymap to your liking
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "n",
        desc = "Format buffer",
      },
    },
    -- Everything in opts will be passed to setup()
    opts = {
      log_level = vim.log.levels.ERROR,
      -- Define your formatters
      formatters_by_ft = {
        css = { "prettierd" },
        dart = { "dart_format" },
        html = { "djlint" },
        lua = { "stylua" },
        javascript = { "prettierd", "eslint_d" },
        json = { { "prettierd" } },
        sql = { "pg_format" },
        typescript = { "prettierd", "eslint_d" },
        typescriptreact = { "prettierd", "eslint_d" },
        xml = { 'xmllint' },
      },
      -- Set up format-on-save
      format_on_save = { timeout_ms = 5000, lsp_fallback = true },
      -- Customize formatters
      formatters = {
        sqlfluff = {
          args = { "format", "--disable-progress-bar", "--dialect=postgres", "-" },
        },
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },

  'tpope/vim-rails',
  {
    'mrcjkb/rustaceanvim',
    version = '^4', -- Recommended
    ft = { 'rust' },
  },

  {
    "zbirenbaum/copilot.lua",
    -- opts = {
    --   suggestion = { enabled = true }, auto_trigger = true, keymap = { accept = "<TAB>" },
    -- }
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({})
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup {
        formatters = {
          insert_text = require("copilot_cmp.format").remove_existing
        },
      }
    end
  },

  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- optional
    },
    config = function()
      require("nvim-tree").setup {}
    end
  },

  'madox2/vim-ai',

  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" }
    },
  },

  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim', tag = "legacy" },

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',

      'hrsh7th/cmp-nvim-lsp',
    },
  },

  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup {
        shortcut_type = 'number',
        change_to_vcs_root = true,
        config = {
          week_header = {
            enable = true,
          },
        },
      }
    end,
    dependencies = { { 'nvim-tree/nvim-web-devicons' } }
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "macchiato",
      background = {
        light = "latte",
        dark = "macchiato",
      },
      transparent_background = false,
    }
  }
  -- {
  --     'goolord/alpha-nvim',
  --     dependencies = { 'nvim-tree/nvim-web-devicons' },
  --     config = function ()
  --         require'alpha'.setup(require'alpha.themes.startify'.config)
  --     end
  -- }
}
