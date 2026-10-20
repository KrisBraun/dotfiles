return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        css = { "prettierd" },
        dart = { "dart_format" },
        html = { "djlint" },
        lua = { "stylua" },
        javascript = { "prettier" },
        json = { "fixjson" },
        sql = { "pg_format" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        xml = { "xmllint" },
      },
    },
  },
}
