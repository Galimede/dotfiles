vim.schedule(function()
  local Snacks = require("snacks")

  Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
  Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
  Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
  Snacks.toggle.diagnostics():map("<leader>ud")
  Snacks.toggle.line_number():map("<leader>un")
  Snacks.toggle.inlay_hints():map("<leader>ui")
  Snacks.toggle.treesitter():map("<leader>ut")

  Snacks.toggle({
    name = "Auto Formatting",
    get = function()
      return not vim.g.disable_autoformat and not vim.b.disable_autoformat
    end,
    set = function(state)
      if state then
        vim.g.disable_autoformat = false
        vim.b.disable_autoformat = false
      else
        vim.g.disable_autoformat = true
      end
    end,
  }):map("<leader>uf")

  Snacks.toggle({
    name = "Auto Formatting (Buffer)",
    get = function()
      return not vim.b.disable_autoformat
    end,
    set = function(state)
      vim.b.disable_autoformat = not state
    end,
  }):map("<leader>uF")
end)

return {
  toggle = { enabled = true },
}
