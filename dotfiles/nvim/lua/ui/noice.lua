require("noice").setup({
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = true,
    lsp_doc_border = true,
  },
  routes = {
    -- Hide "written" messages
    {
      filter = {
        event = "msg_show",
        kind = "",
        find = "written",
      },
      opts = { skip = true },
    },
  },
})

-- Noice keymaps
vim.keymap.set("n", "<leader>snh", "<cmd>Noice history<cr>", { desc = "Noice History" })
vim.keymap.set("n", "<leader>snl", "<cmd>Noice last<cr>", { desc = "Noice Last Message" })
vim.keymap.set("n", "<leader>snd", "<cmd>Noice dismiss<cr>", { desc = "Dismiss All Notifications" })
vim.keymap.set("n", "<leader>snt", "<cmd>Noice pick<cr>", { desc = "Noice Picker" })
vim.keymap.set({ "i", "n", "s" }, "<C-f>", function()
  if not require("noice.lsp").scroll(4) then return "<C-f>" end
end, { silent = true, expr = true, desc = "Scroll forward" })
vim.keymap.set({ "i", "n", "s" }, "<C-b>", function()
  if not require("noice.lsp").scroll(-4) then return "<C-b>" end
end, { silent = true, expr = true, desc = "Scroll backward" })
