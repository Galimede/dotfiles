-- Treesitter grammars are installed via Nix (withAllGrammars)
-- Highlighting is built-in in Neovim 0.11+

-- Textobjects setup with lookahead
require("nvim-treesitter-textobjects").setup({
  select = {
    lookahead = true,
  },
})

local select = require("nvim-treesitter-textobjects.select")
local move = require("nvim-treesitter-textobjects.move")
local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

-- Selection textobjects
vim.keymap.set({ "x", "o" }, "af", function() select.select_textobject("@function.outer") end, { desc = "Around function" })
vim.keymap.set({ "x", "o" }, "if", function() select.select_textobject("@function.inner") end, { desc = "Inside function" })
vim.keymap.set({ "x", "o" }, "ac", function() select.select_textobject("@class.outer") end, { desc = "Around class" })
vim.keymap.set({ "x", "o" }, "ic", function() select.select_textobject("@class.inner") end, { desc = "Inside class" })
vim.keymap.set({ "x", "o" }, "aa", function() select.select_textobject("@parameter.outer") end, { desc = "Around argument" })
vim.keymap.set({ "x", "o" }, "ia", function() select.select_textobject("@parameter.inner") end, { desc = "Inside argument" })

-- Movement textobjects
vim.keymap.set({ "n", "x", "o" }, "]m", function() move.goto_next_start("@function.outer") end, { desc = "Next function start" })
vim.keymap.set({ "n", "x", "o" }, "]M", function() move.goto_next_end("@function.outer") end, { desc = "Next function end" })
vim.keymap.set({ "n", "x", "o" }, "]]", function() move.goto_next_start("@class.outer") end, { desc = "Next class start" })
vim.keymap.set({ "n", "x", "o" }, "][", function() move.goto_next_end("@class.outer") end, { desc = "Next class end" })
vim.keymap.set({ "n", "x", "o" }, "[m", function() move.goto_previous_start("@function.outer") end, { desc = "Previous function start" })
vim.keymap.set({ "n", "x", "o" }, "[M", function() move.goto_previous_end("@function.outer") end, { desc = "Previous function end" })
vim.keymap.set({ "n", "x", "o" }, "[[", function() move.goto_previous_start("@class.outer") end, { desc = "Previous class start" })
vim.keymap.set({ "n", "x", "o" }, "[]", function() move.goto_previous_end("@class.outer") end, { desc = "Previous class end" })

-- Repeatable moves with ; and ,
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

-- Autotag for HTML/JSX
require("nvim-ts-autotag").setup()
