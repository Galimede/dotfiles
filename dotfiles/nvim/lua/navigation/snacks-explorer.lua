vim.keymap.set("n", "<leader>e", function()
  require("snacks").explorer()
end, { desc = "File Explorer" })

return {
  explorer = {
    enabled = true,
    replace_netrw = true,
  },
}
