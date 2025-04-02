return {
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- optional for vim.ui.select
    },
    config = true,
    opts = {
      flutter_path = nil,
      flutter_lookup_cmd = "asdf where flutter",
      fvm = false,
      widget_guides = { enabled = true },
      lsp = {
        settings = {
          showtodos = true,
          completefunctioncalls = true,
          analysisexcludedfolders = {
            vim.fn.expand("$Home/.pub-cache"),
          },
          renamefileswithclasses = "prompt",
          updateimportsonrename = true,
          enablesnippets = false,
        },
      },
      debugger = {
        enabled = true,
        run_via_dap = true,
        exception_breakpoints = {},
        register_configurations = function(paths)
          local dap = require("dap")
          -- See also: https://github.com/akinsho/flutter-tools.nvim/pull/292
          dap.adapters.dart = {
            type = "executable",
            command = paths.flutter_bin,
            args = { "debug-adapter" },
          }
          dap.configurations.dart = {
            {
              type = "dart",
              request = "launch",
              name = "Launch Flutter App",
              -- Need to find a way to make this dyanmic
              program = "${workspaceFolder}/apps/plot/lib/main.dart",
              cwd = "${workspaceFolder}/apps/plot",
            },
            {
              type = "dart",
              request = "attach",
              name = "Attach Flutter App",
              -- Need to find a way to make this dyanmic
              -- program = "${workspaceFolder}/apps/plot/lib/main.dart",
              cwd = "${workspaceFolder}/apps/plot",
            },
          }
          require("dap.ext.vscode").load_launchjs()
        end,
      },
    },
  },
}
