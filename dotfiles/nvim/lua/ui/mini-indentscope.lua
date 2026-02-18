require("mini.indentscope").setup({
  symbol = "│",
  options = { try_as_border = true },
})

-- Disable for certain filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "man", "notify", "noice", "snacks_dashboard", "Trouble" },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})
