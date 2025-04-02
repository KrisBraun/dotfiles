return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    table.insert(opts.sections.lualine_x, {
      function()
        if vim.bo.modified then
          return "✏️" -- Icon for modified buffer
        else
          return ""
        end
      end,
    })
  end,
}
