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
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
    config = function()
      local servers = {
        tsserver = {},
        solargraph = {},
      }

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
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
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
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        },
      }

      if next(vim.fn.argv()) == nil then
        vim.cmd([[
          augroup startup
            autocmd!
            autocmd VimEnter * Telescope oldfiles
          augroup end
        ]])
      end


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
            settings = servers[server_name],
          }
        end
      }

      -- Turn on lsp status information
      require('fidget').setup()
    end
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
      require('telescope').setup {
        pickers = {
          git_branches = {
            initial_mode = "normal",
          },
          oldfiles = {
            initial_mode = "normal",
          }
        }
      }
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
