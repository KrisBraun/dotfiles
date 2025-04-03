return {
  -- mini.pairs
  {
    "echasnovski/mini.pairs",
    opts = {
      -- disable in command mode so we don't add closing brackets to search
      modes = { insert = true, command = false, terminal = false },
    },
  },
}
