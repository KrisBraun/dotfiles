return {
  {
    "folke/flash.nvim",
    opts = {
      modes = {
        search = {
          enabled = true,
        },
      },
    },
    keys = {
      -- disable the default flash keymap
      { "s", mode = { "n", "x", "o" }, false },
    },
  },
}
