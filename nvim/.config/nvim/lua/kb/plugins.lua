require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  use {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeoutlen = 300
      require("which-key").setup { }
    end
  }

  use { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    requires = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
  }

  use { -- Autocompletion
    'hrsh7th/nvim-cmp',
    requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  }

  use { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }

  use { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  use {
    'nvim-tree/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup()
    end
  } 

  -- Git related plugins
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'lewis6991/gitsigns.nvim'

  use 'navarasu/onedark.nvim' -- Theme inspired by Atom
  use {
    'nvim-lualine/lualine.nvim', -- Fancier statusline
      config = function()
        -- Set lualine as statusline
        -- See `:help lualine.txt`
        require('lualine').setup {
          options = {
            icons_enabled = false,
          },
          sections = {
            lualine_c = { { 'filename', path = 1, } },
          },
        }
      end
  }
  use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
  use {
      'numToStr/Comment.nvim', -- "gc" to comment visual regions/lines
      config = function()
          require('Comment').setup()
      end
  }
  use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically
  use 'farmergreg/vim-lastplace'
  use 'tpope/vim-unimpaired'
  use 'svermeulen/vim-subversive'

  -- Fuzzy Finder (files, lsp, etc)
  use {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup()
    end
  }

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

  use({
    "windwp/nvim-autopairs", -- auto close sybmols
    config = function()
      require("nvim-autopairs").setup({
        map_cr = true, -- send closing symbol to its own line
        check_ts = true, -- use treesitter
      })
    end,
    disable_filetype = { "TelescopePrompt", "fugitive" },
  })

  use 'windwp/nvim-ts-autotag'

  vim.g.neoformat_try_node_exe = true
  use 'sbdchd/neoformat'
  vim.cmd([[
    augroup fmt
      autocmd!
      au BufWritePre * try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry
    augroup END
  ]])

  use 'tpope/vim-rails'

  if is_bootstrap then
    require('packer').sync()
  end
end)
