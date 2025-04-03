return {
  {
    "tpope/vim-fugitive",
    keys = {
      --
      {
        "<leader>gd",
        ":Gdiffsplit<CR>",
        mode = { "n", "x", "o" },
        desc = "Open Git Diff (split)",
        remap = true,
      },
      {
        "<leader>gD",
        function()
          Snacks.picker.git_diff()
        end,
        mode = { "n", "x", "o" },
        desc = "Git Diff (hunks)",
        remap = false,
      },
    },
  },
}
