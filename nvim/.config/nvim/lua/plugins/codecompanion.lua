return {
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
    },
    cmd = "MCPHub",
    build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module"ravitemer/mcphub.nvim",
    keys = {
      { "<leader>am", "<cmd>MCPHub<cr>", mode = "n", desc = "MCPHub" },
    },
    opts = {
      port = 37373,
      config = vim.fn.expand("~/.config/nvim/mcpservers.json"),
    },
  },
  -- {
  --   "Davidyz/VectorCode",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   build = "uv tool install --force vectorcode",
  --   cmd = "VectorCode",
  --   opts = {},
  -- },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
      "ravitemer/mcphub.nvim",
      -- "Davidyz/VectorCode",
    },
    opts = {
      -- adapters = {
      --   azure_openai = function()
      --     return require("codecompanion.adapters").extend("azure_openai", {
      --       env = {
      --         api_key = "AZURE_API_KEY",
      --         endpoint = "AZURE_API_BASE",
      --         api_version = "AZURE_API_VERSION",
      --       },
      --       schema = {
      --         model = {
      --           default = "o3-mini",
      --           choices = {
      --             ["o3-mini"] = { opts = { can_reason = true } },
      --             ["o1"] = { opts = { stream = false } },
      --             ["o1-mini"] = { opts = { stream = true } },
      --             "gpt-4o",
      --             "gpt-4o-mini",
      --           },
      --         },
      --       },
      --     })
      --   end,
      -- },
      strategies = {
        chat = {
          adapter = "openai",
          keymaps = {
            close = {
              modes = {
                n = "q",
              },
              index = 3,
              callback = "keymaps.close",
              description = "Close Chat",
            },
            stop = {
              modes = {
                n = "<C-c",
              },
              index = 4,
              callback = "keymaps.stop",
              description = "Stop Request",
            },
          },
          -- slash_commands = {
          --   codebase = require("vectorcode.integrations").codecompanion.chat.make_slash_command(),
          -- },
          tools = {
            mcp = {
              -- calling it in a function would prevent mcphub from being loaded before it's needed
              callback = function()
                return require("mcphub.extensions.codecompanion")
              end,
              description = "Call tools and resources from the MCP Servers",
              opts = {
                requires_approval = true,
              },
            },
            -- vectorcode = {
            --   description = "Run VectorCode to retrieve the project context.",
            --   callback = require("vectorcode.integrations").codecompanion.chat.make_tool(),
            -- },
          },
        },
        inline = {
          adapter = "openai",
        },
      },
    },
    keys = {
      { "<leader>a", "", desc = "ai" },
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanion actions" },
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "CodeCompanion chat" },
      { "<leader>ay", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "CodeCompanion add to chat" },
      { "<leader>ai", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "CodeCompanion inline" },
    },
  },
}
