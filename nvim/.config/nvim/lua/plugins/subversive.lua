return {
  {
    "svermeulen/vim-subversive",
    lazy = true,
    keys = {
      { "s", "<plug>(SubversiveSubstitute)", mode = { "n", "x" } },
      { "ss", "<plug>(SubversiveSubstituteLine)", mode = "n" },
      { "S", "<plug>(SubversiveSubstituteToEndOfLine)", mode = "n" },
    },
  },
}
