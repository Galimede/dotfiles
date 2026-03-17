vim.keymap.set("n", "<leader>tt", function()
  require("snacks").terminal()
end, { desc = "Toggle terminal" })

vim.keymap.set("n", "<leader>ft", function()
  require("snacks").terminal()
end, { desc = "Terminal (root dir)" })

vim.keymap.set("n", "<leader>fT", function()
  require("snacks").terminal(nil, { cwd = vim.fn.expand("%:p:h") })
end, { desc = "Terminal (cwd)" })

vim.keymap.set("n", "<C-/>", function()
  require("snacks").terminal()
end, { desc = "Toggle terminal" })

vim.keymap.set("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide terminal" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

return {
  terminal = {
    enabled = true,
    win = {
      position = "float",
    },
  },
}
