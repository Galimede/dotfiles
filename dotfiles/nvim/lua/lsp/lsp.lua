-- Enable all LSP servers (configs are in lsp/ directory, auto-discovered by Neovim 0.11+)
vim.lsp.enable({
  "vtsls",
  "eslint",
  "nil_ls",
  "lua_ls",
  "html_ls",
  "json_ls",
  "stylelint_ls",
  "bashls",
  "marksman",
})

-- Diagnostic config
vim.diagnostic.config({
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.HINT] = "󰌵",
      [vim.diagnostic.severity.INFO] = "",
    },
  },
  virtual_text = {
    spacing = 4,
    prefix = "●",
  },
  underline = true,
  update_in_insert = false,
})

-- Remove Neovim 0.11 default LSP keymaps that conflict
pcall(vim.keymap.del, "n", "grr")
pcall(vim.keymap.del, "n", "gra")
pcall(vim.keymap.del, "n", "grn")
pcall(vim.keymap.del, "n", "gri")

-- LSP keymaps via snacks picker
vim.keymap.set({ "n", "v" }, "gd", function() require("snacks").picker.lsp_definitions() end, { desc = "LSP: Goto Definition" })
vim.keymap.set({ "n", "v" }, "gI", function() require("snacks").picker.lsp_implementations() end, { desc = "LSP: Goto Implementation" })
vim.keymap.set({ "n", "v" }, "gy", function() require("snacks").picker.lsp_type_definitions() end, { desc = "LSP: Goto Type Definition" })
vim.keymap.set({ "n", "v" }, "gu", function() require("snacks").picker.lsp_references() end, { desc = "LSP: Goto Usages" })

-- gD: definition in split
vim.keymap.set({ "n", "v" }, "gD", function()
  vim.lsp.buf.definition({
    on_list = function(options)
      vim.cmd("vsplit")
      local item = options.items[1]
      vim.cmd("edit " .. item.filename)
      vim.api.nvim_win_set_cursor(0, { item.lnum, item.col - 1 })
    end,
  })
end, { desc = "LSP: Goto Definition (Split)" })

-- Diagnostic navigation
vim.keymap.set({ "n", "v" }, "D", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set({ "n", "v" }, "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next Diagnostic" })
vim.keymap.set({ "n", "v" }, "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev Diagnostic" })

-- Code actions
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set({ "n", "v" }, "<leader>cA", function()
  vim.lsp.buf.code_action({ context = { only = { "source" }, diagnostics = {} } })
end, { desc = "Source Action" })

-- Rename (via inc-rename)
require("inc_rename").setup()
vim.keymap.set("n", "<leader>cr", function()
  return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true, desc = "Rename" })

-- Hover
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })

-- vtsls: go to source definition
vim.keymap.set("n", "gS", function()
  local clients = vim.lsp.get_clients({ name = "vtsls" })
  if #clients > 0 then
    local client = clients[1]
    client:exec_cmd({
      command = "typescript.goToSourceDefinition",
      title = "Go to Source Definition",
      arguments = {
        vim.uri_from_bufnr(0),
        vim.lsp.util.make_position_params(0, client.offset_encoding).position,
      },
    })
  else
    vim.lsp.buf.declaration()
  end
end, { desc = "LSP: Goto Source Definition" })

-- Setup lazydev for Neovim Lua API
require("lazydev").setup()

-- Todo comments
require("todo-comments").setup()
vim.keymap.set("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next todo comment" })
vim.keymap.set("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Previous todo comment" })
vim.keymap.set("n", "<leader>st", "<cmd>TodoTelescope<cr>", { desc = "Todo Comments" })
