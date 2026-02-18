require("mini.files").setup()

vim.keymap.set("n", "<leader>E", function()
  require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
end, { desc = "Mini Files (current file)" })

-- Rename integration with snacks LSP rename
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesActionRename",
  callback = function(event)
    require("snacks").rename.on_rename_file(event.data.from, event.data.to)
  end,
})
