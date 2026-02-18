local map = function(lhs, rhs, desc)
  vim.keymap.set({ "n", "v" }, lhs, rhs, { desc = desc })
end

-- Find
map("<leader><space>", function() require("snacks").picker.smart() end, "Find Files (Smart)")
map("<leader>ff", function() require("snacks").picker.files() end, "Find Files")
map("<leader>,", function() require("snacks").picker.buffers() end, "Buffers")
map("<leader>/", function() require("snacks").picker.grep() end, "Grep")
map("<leader>:", function() require("snacks").picker.command_history() end, "Command History")
map("<leader>fr", function() require("snacks").picker.recent() end, "Recent Files")

-- Search
map("<leader>ss", function() require("snacks").picker.lsp_symbols() end, "LSP Symbols")
map("<leader>sS", function() require("snacks").picker.lsp_workspace_symbols() end, "LSP Workspace Symbols")
map("<leader>sd", function() require("snacks").picker.diagnostics() end, "Diagnostics")
map("<leader>sg", function() require("snacks").picker.grep() end, "Grep")
map("<leader>sr", function() require("snacks").picker.resume() end, "Resume Last Picker")
map("<leader>sh", function() require("snacks").picker.help() end, "Help Pages")
map("<leader>sk", function() require("snacks").picker.keymaps() end, "Keymaps")

return {
  picker = {
    enabled = true,
    win = {
      input = {
        keys = {
          ["<C-h>"] = { "toggle_hidden", mode = { "i", "n" } },
          ["<C-i>"] = { "toggle_ignored", mode = { "i", "n" } },
          ["<C-g>"] = { "toggle_follow", mode = { "i", "n" } },
          ["<C-q>"] = { "qflist", mode = { "n", "i" } },
        },
      },
    },
  },
}
