vim.keymap.set("n", "<leader>tt", function()
  require("snacks").terminal()
end, { desc = "Toggle terminal" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

return {
  terminal = {
    enabled = true,
    win = {
      position = "float",
    },
  },
}
