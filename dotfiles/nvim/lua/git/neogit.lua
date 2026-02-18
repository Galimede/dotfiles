require("neogit").setup({
  integrations = {
    diffview = false,
  },
})

vim.keymap.set("n", "<leader>gg", function()
  require("neogit").open()
end, { desc = "Neogit" })
