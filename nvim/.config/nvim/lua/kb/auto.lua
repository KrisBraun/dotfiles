vim.cmd([[
  augroup ruby_freeze_string_literals
    autocmd!
    autocmd BufNewFile *.rb 0norm A# frozen_string_literal: true
  augroup end
]])

vim.api.nvim_create_autocmd({ "TextChanged" }, {
  callback = function()
    local lint_status, lint = pcall(require, "lint")
    if lint_status then
      lint.try_lint()
    end
  end,
})
