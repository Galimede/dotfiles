require("catppuccin").setup({
  flavour = "mocha",
  integrations = {
    blink_cmp = true,
    flash = true,
    gitsigns = true,
    lsp_trouble = true,
    mini = { enabled = true },
    neogit = true,
    noice = true,
    render_markdown = true,
    snacks = true,
    treesitter = true,
    which_key = true,
  },
})

vim.cmd.colorscheme("catppuccin")
