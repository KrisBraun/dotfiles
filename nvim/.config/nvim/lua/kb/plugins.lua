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
    'saghen/blink.cmp',
    lazy = false, -- lazy loading handled internally
    -- optional: provides snippets for the snippet source
    dependencies = {
      'rafamadriz/friendly-snippets',
      'L3MON4D3/LuaSnip',
    },
    -- use a release tag to download pre-built binaries
    version = 'v0.*',
    -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'enter',
      },
      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
      },
      snippets = {
        expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
        active = function(filter)
          if filter and filter.direction then
            return require('luasnip').jumpable(filter.direction)
          end
          return require('luasnip').in_snippet()
        end,
        jump = function(direction) require('luasnip').jump(direction) end,
      },
      -- default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, via `opts_extend`
      sources = {
        default = { "lsp", "path", "luasnip", "buffer" },
      },
      -- experimental signature help support
      -- signature = { enabled = true }
    },
    -- allows extending the providers array elsewhere in your config
    -- without having to redefine it
    opts_extend = { "sources.default" }
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    -- branch = "master",
    -- commit = "f2778bd1a28b74adf5b1aa51aa57da85adfa3d16",
    build = ':TSUpdate',
  },

  {
    -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    -- branch = "master",
    -- commit = "35a60f093fa15a303874975f963428a5cd24e4a0",
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
  'tpope/vim-repeat',
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
          initial_mode = 'normal',
        },
        oldfiles = {
          initial_mode = 'normal',
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
        javascript = { "eslint" },
        typescript = { "eslint" },
        javascriptreact = { "eslint" },
        typescriptreact = { "eslint" },
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
        javascript = { "prettierd" },
        json = { { "fixjson" } },
        sql = { "pg_format" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
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

  {
    'code-biscuits/nvim-biscuits',
    requires = {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate'
    },
    opts = {
      ensure_installed = "maintained",
      cursor_line_only = true,
    }
  },

  'tpope/vim-rails',
  {
    'mrcjkb/rustaceanvim',
    version = '^4', -- Recommended
    ft = { 'rust' },
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          hide_during_completion = true,
          debounce = 75,
          keymap = {
            accept = "<TAB>",
            accept_word = false,
            accept_line = false,
            next = "<S-TAB>",
          },
        },
        panel = { enabled = false },
      })
    end,
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
    "robitx/gp.nvim",
    config = function()
      local conf = {
        openai_api_key = { "cat", "/Users/kris.braun/.config/openai.token" },
        chat_template = "# topic: ?\n\n"
            .. "- file: %s\n"
            .. "---\n"
            .. "🗨: ",
        chat_free_cursor = true,
        chat_shortcut_respond = { modes = { "n", "v", "x" }, shortcut = "<leader><leader>" },
        chat_shortcut_delete = { modes = { "n", "v", "x" }, shortcut = "<leader>cd" },
        chat_shortcut_stop = { modes = { "n", "v", "x" }, shortcut = "<leader>cs" },
      }
      require("gp").setup(conf)

      -- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
    end,
  },

  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" }
    },
  },
  -- LSP servers and clients communicate which features they support through "capabilities".
  --  By default, Neovim supports a subset of the LSP specification.
  --  With blink.cmp, Neovim has *more* capabilities which are communicated to the LSP servers.
  --  Explanation from TJ: https://youtu.be/m8C0Cq9Uv9o?t=1275
  --
  -- This can vary by config, but in general for nvim-lspconfig:

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'j-hui/fidget.nvim', tag = "legacy" },
      'folke/neodev.nvim',
      'saghen/blink.cmp',
    },
    -- example using `opts` for defining servers
    opts = {
      servers = {
        lua_ls = {}
      }
    },
    config = function(_, opts)
      local lspconfig = require('lspconfig')
      for server, config in pairs(opts.servers) do
        -- passing config.capabilities to blink.cmp merges with the capabilities in your
        -- `opts[server].capabilities, if you've defined it
        config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end
    end
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
}
