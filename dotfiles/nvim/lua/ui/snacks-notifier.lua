vim.keymap.set("n", "<leader>sn", function()
  require("snacks").notifier.show_history()
end, { desc = "Show notification history" })

vim.keymap.set("n", "<leader>un", function()
  require("snacks").notifier.hide()
end, { desc = "Hide notifications" })

return {
  notifier = { enabled = true },
}
