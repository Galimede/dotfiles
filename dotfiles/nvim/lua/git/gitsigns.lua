require("gitsigns").setup({
  on_attach = function(bufnr)
    local gs = require("gitsigns")
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    -- Navigation
    map("n", "]h", function() gs.nav_hunk("next") end, "Next hunk")
    map("n", "[h", function() gs.nav_hunk("prev") end, "Previous hunk")

    -- Actions
    map("n", "<leader>ghs", gs.stage_hunk, "Stage hunk")
    map("n", "<leader>ghr", gs.reset_hunk, "Reset hunk")
    map("v", "<leader>ghs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage hunk")
    map("v", "<leader>ghr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset hunk")
    map("n", "<leader>ghS", gs.stage_buffer, "Stage buffer")
    map("n", "<leader>ghR", gs.reset_buffer, "Reset buffer")
    map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo stage hunk")
    map("n", "<leader>ghp", gs.preview_hunk, "Preview hunk")
    map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line")
    map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle line blame")
  end,
})
