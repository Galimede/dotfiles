require("flash").setup()

vim.keymap.set({ "n", "x", "o" }, "<A-o>", function()
  require("flash").treesitter({
    actions = {
      ["<A-o>"] = "next",
      ["<A-i>"] = "prev",
    },
  })
end, { desc = "Treesitter incremental selection" })

vim.keymap.set({ "n", "x", "o" }, "s", function()
  require("flash").jump()
end, { desc = "Flash" })

vim.keymap.set({ "n", "x", "o" }, "S", function()
  require("flash").treesitter()
end, { desc = "Flash Treesitter" })

vim.keymap.set("o", "r", function()
  require("flash").remote()
end, { desc = "Remote Flash" })
