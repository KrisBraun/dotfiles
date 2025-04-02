-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = LazyVim.safe_keymap_set

-- Lazy
-- Remove <leader>l so we can also use it for Linear below
vim.keymap.del("n", "<leader>l")
map("n", "<leader>ll", ":Lazy<CR>", { desc = "Open Lazy", remap = false })
map("n", "<leader>le", ":LazyExtras<CR>", { desc = "Open Lazy Extras", remap = false })

-- Windows
map("n", "<leader>\\", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>=", "<C-W>c", { desc = "Close Window", remap = true })

-- Linear
map("n", "<leader>la", function()
  require("linear-nvim").show_assigned_issues()
end)
map("v", "<leader>lc", function()
  require("linear-nvim").create_issue()
end)
map("n", "<leader>lc", function()
  require("linear-nvim").create_issue()
end)
map("n", "<leader>ld", function()
  require("linear-nvim").show_issue_details()
end)

-- Diagnostics
map("n", "<leader>'", vim.diagnostic.open_float, { desc = "Show diagnostics under the cursor" })

-- Telescope
map("n", "<leader>sr", function()
  Snacks.picker.resume()
end, { desc = "Resume" })
