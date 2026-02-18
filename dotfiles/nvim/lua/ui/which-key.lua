require("which-key").setup({
  plugins = {
    spelling = { enabled = true },
  },
})

require("which-key").add({
  { "<leader>b", group = "Buffers" },
  { "<leader>c", group = "Code" },
  { "<leader>e", group = "Explorer" },
  { "<leader>f", group = "Find" },
  { "<leader>g", group = "Git" },
  { "<leader>gh", group = "Hunks" },
  { "<leader>q", group = "Session/Quit" },
  { "<leader>s", group = "Search" },
  { "<leader>t", group = "Terminal" },
  { "<leader>u", group = "UI/Toggles" },
  { "<leader>w", group = "Window" },
  { "<leader>x", group = "Diagnostics/Quickfix" },
})
