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
        color = {
          enabled = true,
        },
      },
      dev_log = {
        enabled = true,
        filter = nil, -- optional callback to filter the log
        -- takes a log_line as string argument; returns a boolean or nil;
        -- the log_line is only added to the output if the function returns true
        notify_errors = false, -- if there is an error whilst running then notify the user
        open_cmd = "15split", -- command to use to open the log buffer
        focus_on_open = true, -- focus on the newly opened log window
      },
      debugger = {
        enabled = false,
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
          require("dap.ext.vscode").load_launchjs()
        end,
      },
    },
    keys = {
      { "<leader>yl", "<cmd>FlutterLogToggle<CR>", desc = "Flutter Log Toggle" },
      { "<leader>yc", "<cmd>FlutterLogClear<CR>", desc = "Flutter Log Clear" },
      { "<leader>yr", "<cmd>FlutterRestart<CR>", desc = "Flutter Restart" },
      { "<leader>yR", "<cmd>FlutterRun<CR>", desc = "Flutter Run" },
      { "<leader>yt", "<cmd>FlutterCopyProfilerUrl<CR>", desc = "Flutter Copy Profile URL" },
    },
  },
}
