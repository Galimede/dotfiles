local mc = require("multicursor-nvim")
mc.setup()

-- Layer keymaps: only active when multiple cursors exist
mc.addKeymapLayer(function(layerSet)
  layerSet({ "n", "x" }, "<left>", mc.prevCursor, { desc = "Previous cursor" })
  layerSet({ "n", "x" }, "<right>", mc.nextCursor, { desc = "Next cursor" })
  layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor, { desc = "Delete cursor" })
  layerSet("n", "<Esc>", function()
    if not mc.cursorsEnabled() then
      mc.enableCursors()
    else
      mc.clearCursors()
    end
  end)
end)

-- Zed Vim-style keymaps
vim.keymap.set({ "n", "x" }, "gl", function() mc.matchAddCursor(1) end, { desc = "Add cursor at next match" })
vim.keymap.set({ "n", "x" }, "gL", function() mc.matchAddCursor(-1) end, { desc = "Add cursor at prev match" })
vim.keymap.set({ "n", "x" }, "g>", function() mc.matchSkipCursor(1) end, { desc = "Skip match, add next" })
vim.keymap.set({ "n", "x" }, "g<", function() mc.matchSkipCursor(-1) end, { desc = "Skip match, add prev" })
vim.keymap.set({ "n", "x" }, "ga", mc.matchAllAddCursors, { desc = "Add cursors to all matches" })

-- Visual mode: cursors at ends/starts of lines
vim.keymap.set("x", "gA", mc.appendVisual, { desc = "Append cursor at end of lines" })
vim.keymap.set("x", "gI", mc.insertVisual, { desc = "Insert cursor at start of lines" })

-- Line-based add cursor
vim.keymap.set({ "n", "x" }, "<M-k>", function() mc.lineAddCursor(-1) end, { desc = "Add cursor to line above" })
vim.keymap.set({ "n", "x" }, "<M-j>", function() mc.lineAddCursor(1) end, { desc = "Add cursor to line below" })

-- Transpose
vim.keymap.set("x", "<M-t>", function() mc.transposeCursors(1) end, { desc = "Rotate cursor text forward" })
vim.keymap.set("x", "<M-T>", function() mc.transposeCursors(-1) end, { desc = "Rotate cursor text backward" })

-- Align
vim.keymap.set("n", "<M-A>", mc.alignCursors, { desc = "Align cursor columns" })

-- Restore
vim.keymap.set("n", "<M-u>", mc.restoreCursors, { desc = "Restore cleared cursors" })
