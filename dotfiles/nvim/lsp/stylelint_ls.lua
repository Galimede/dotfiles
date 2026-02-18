---@type vim.lsp.Config
return {
  cmd = { "stylelint-lsp", "--stdio" },
  filetypes = { "css", "scss", "less" },
  root_markers = {
    ".stylelintrc",
    ".stylelintrc.json",
    ".stylelintrc.yml",
    ".stylelintrc.yaml",
    ".stylelintrc.js",
    ".stylelintrc.cjs",
    "stylelint.config.js",
    "stylelint.config.cjs",
    "stylelint.config.mjs",
  },
  settings = {},
}
