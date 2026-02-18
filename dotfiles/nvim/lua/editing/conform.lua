require("conform").setup({
  notify_on_error = true,

  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return {
      timeout_ms = 500,
      lsp_fallback = true,
    }
  end,

  formatters_by_ft = {
    lua = { "stylua" },
    nix = { "nixfmt" },
    javascript = { "prettierd", stop_after_first = true },
    javascriptreact = { "prettierd", stop_after_first = true },
    typescript = { "prettierd", stop_after_first = true },
    typescriptreact = { "prettierd", stop_after_first = true },
    css = { "prettierd", stop_after_first = true },
    scss = { "prettierd", stop_after_first = true },
    html = { "prettierd", stop_after_first = true },
    json = { "prettierd", stop_after_first = true },
    jsonc = { "prettierd", stop_after_first = true },
    yaml = { "prettierd", stop_after_first = true },
    markdown = { "prettierd", stop_after_first = true },
  },

  formatters = {
    stylua = {
      args = { "--indent-type", "Spaces", "--indent-width", "2", "--stdin-filepath", "$FILENAME", "-" },
    },
  },
})
