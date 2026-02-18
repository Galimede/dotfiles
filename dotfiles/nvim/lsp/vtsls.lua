---@type vim.lsp.Config
return {
  cmd = { "vtsls", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
  settings = {
    vtsls = {
      autoUseWorkspaceTsdk = true,
      enableMoveToFileCodeAction = true,
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
          entriesLimit = 50,
        },
      },
    },
    typescript = {
      suggest = { completeFunctionCalls = true },
      preferences = {
        importModuleSpecifier = "relative",
        useAliasesForRenames = false,
        format = { enable = false },
      },
    },
    javascript = {
      suggest = { completeFunctionCalls = true },
      preferences = {
        importModuleSpecifier = "relative",
        useAliasesForRenames = false,
        format = { enable = false },
      },
    },
  },
}
