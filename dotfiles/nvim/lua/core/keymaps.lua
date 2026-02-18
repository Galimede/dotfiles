local map = vim.keymap.set

-- Black hole register: d deletes without yanking, leader+d uses default register
map({ "n", "v" }, "d", '"_d', { desc = "Delete (no yank)" })
map({ "n", "v" }, "D", '"_D', { desc = "Delete to end (no yank)" })
map({ "n", "v" }, "x", '"_x', { desc = "Delete char (no yank)" })
map({ "n", "v" }, "<leader>d", "d", { desc = "Delete (yank)" })
map({ "n", "v" }, "<leader>D", "D", { desc = "Delete to end (yank)" })

-- Disable gU (use ~ for case toggling instead)
map({ "n", "v" }, "gU", "<Nop>")

-- Better escape
map("i", "jk", "<Esc>", { desc = "Escape" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Window resize
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Buffer navigation
map("n", "H", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "L", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>bD", "<cmd>bdelete!<cr>", { desc = "Delete buffer (force)" })

-- Move lines
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move line down", silent = true })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move line up", silent = true })

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Clear search highlights
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear highlights" })

-- Quickfix navigation
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Open quickfix list" })
map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Open location list" })
map("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix item" })
map("n", "[q", "<cmd>cprev<cr>", { desc = "Previous quickfix item" })

-- Save with Ctrl+S
map({ "n", "i" }, "<C-s>", "<cmd>w<cr>", { desc = "Save" })

-- Quit/save shortcuts
map("n", "<leader>qq", "<cmd>confirm qa<cr>", { desc = "Quit all" })
map("n", "<leader>ww", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>wa", "<cmd>wa<cr>", { desc = "Save all" })
