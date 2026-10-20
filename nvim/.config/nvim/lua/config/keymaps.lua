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
end, { desc = "Linear Assigned Issues" })
map("v", "<leader>lc", function()
  require("linear-nvim").create_issue()
end, { desc = "Create Linear Issue" })
map("n", "<leader>ld", function()
  require("linear-nvim").show_issue_details()
end, { desc = "Linear Issue Details" })

-- Diagnostics
map("n", "<leader>'", vim.diagnostic.open_float, { desc = "Show diagnostics under the cursor" })

-- Telescope
vim.keymap.set("n", "<leader>sr", function()
  Snacks.picker.actions.focus_list(Snacks.picker.resume())
end, { desc = "Resume" })
vim.keymap.set("n", "<leader>ff", "<leader>fF", { desc = "Search Files", remap = true })

-- Git
vim.keymap.set("n", "<leader>gd", ":Gdiffsplit<CR>", { desc = "Open Git Diff (split)" })
vim.keymap.set("n", "<leader>gD", function()
  Snacks.picker.git_diff()
end, { desc = "Open Git Diff (hunks)" })

-- Current path
vim.api.nvim_create_user_command("Cppath", function()
  -- Get absolute path of current file and cwd
  local abs_path = vim.fn.expand("%:p")
  local cwd = vim.fn.getcwd()
  -- Make relative path
  local rel_path = vim.fn.fnamemodify(abs_path, ":.:" .. cwd)
  vim.fn.setreg("+", rel_path)
  vim.notify('Copied "' .. rel_path .. '" to the clipboard!')
end, {})

vim.keymap.set("n", "<D-C>", "<cmd>Cppath<cr>", { desc = "Copy relative file path to clipboard" })
