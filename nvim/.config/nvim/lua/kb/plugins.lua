return {
  {
    "folke/which-key.nvim",
    init = function()
      vim.o.timeoutlen = 300
    end
  },

  'lifepillar/pgsql.vim',

  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp"
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = "master", commit = "f2778bd1a28b74adf5b1aa51aa57da85adfa3d16",
    build = ':TSUpdate',
  },

  { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = "master", commit = "35a60f093fa15a303874975f963428a5cd24e4a0",
    dependencies = {'nvim-treesitter'},
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

  'navarasu/onedark.nvim',
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
      'numToStr/Comment.nvim', -- "gc" to comment visual regions/lines
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
        }
      }
    }
  },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = vim.fn.executable 'make' == 1 },

  {
    "windwp/nvim-autopairs", -- auto close sybmols
    config = function()
      local Rule = require('nvim-autopairs.rule')
      local npairs = require('nvim-autopairs')
      npairs.setup({
        map_cr = true, -- send closing symbol to its own line
        check_ts = true, -- use treesitter
      })
      npairs.add_rule(Rule("`","`",{"typescript", "typescriptreact"}))
    end
  },

  'windwp/nvim-ts-autotag',

  'sbdchd/neoformat',

  'tpope/vim-rails',

  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = { enabled = false }, --, auto_trigger = true, keymap = { accept = "<TAB>"} },
    }
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "copilot.lua" },
    config = function ()
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
        {"nvim-lua/plenary.nvim"},
        {"nvim-treesitter/nvim-treesitter"}
    },
  },

  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',

    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      {'j-hui/fidget.nvim', tag = "legacy"},

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',

      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      local servers = {
        tsserver = {},
        solargraph = {},
      }
      -- local filetypes = {
      --   sqlls = {
      --     filetypes = {"sql", "mysql", "pgsql"}
      --   },
      -- }

      -- Setup neovim lua configuration
      require('neodev').setup()

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      -- Setup mason so it can manage external tooling
      require("mason").setup()

      local on_attach = function(_, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

        local nmap = function(keys, func, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end

          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

        nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
        nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
        nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        -- See `:help K` for why this keymap
        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

        -- Lesser used LSP functionality
        nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
        nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
        nmap('<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, '[W]orkspace [L]ist Folders')

        -- Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
          vim.lsp.buf.format()
        end, { desc = 'Format current buffer with LSP' })
      end

      -- nvim-cmp setup
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
      end
      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ["<Tab>"] = vim.schedule_wrap(function(fallback)
            if cmp.visible() and has_words_before() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'copilot' },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        },
        -- sorting = {
        --   priority_weight = 2,
        --   comparators = {
        --     require("copilot_cmp.comparators").prioritize,
        --
        --     -- Below is the default comparitor list and order for nvim-cmp
        --     cmp.config.compare.offset,
        --     cmp.config.compare.exact,
        --     cmp.config.compare.score,
        --     cmp.config.compare.recently_used,
        --     cmp.config.compare.locality,
        --     cmp.config.compare.kind,
        --     cmp.config.compare.sort_text,
        --     cmp.config.compare.length,
        --     cmp.config.compare.order,
        --   },
        -- },
      }

      -- Ensure the servers above are installed
      local mason_lspconfig = require 'mason-lspconfig'
      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers),
      }
      mason_lspconfig.setup_handlers {
        function(server_name)
          require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            --filetypes = filetypes[server_name],
            settings = servers[server_name],
          }
        end
      }

      require'lspconfig'.dartls.setup{}

      -- Turn on lsp status information
      require('fidget').setup()
    end
  },
}
