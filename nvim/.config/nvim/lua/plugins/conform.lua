return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        css = { "prettierd" },
        dart = { "dart_format" },
        html = { "djlint" },
        lua = { "stylua" },
        javascript = { "prettierd" },
        json = { "fixjson" },
        sql = { "pg_format" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        xml = { "xmllint" },
      },
    },
  },
}
