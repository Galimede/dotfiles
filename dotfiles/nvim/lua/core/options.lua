-- Leader keys (must be set before any keymaps)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"

-- Tabs / indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- UI
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.showmode = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.pumheight = 10

-- Editing
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.completeopt = "menu,menuone,noselect"

-- Per-project config
vim.opt.exrc = true

-- Disable unused providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Resize splits on window resize
vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("resize-splits", { clear = true }),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Close some filetypes with q
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("close-with-q", { clear = true }),
  pattern = { "help", "man", "qf", "checkhealth", "notify", "lspinfo", "startuptime" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})
