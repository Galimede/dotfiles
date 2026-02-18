-- Core setup (order matters: options must come first)
require("core.options")
require("core.keymaps")
require("core.colorscheme")
require("core.persistence")

-- Snacks: merge all fragments, then single setup() call
require("snacks").setup(
  vim.tbl_deep_extend(
    "force",
    require("navigation.snacks-picker"),
    require("navigation.snacks-explorer"),
    require("terminal.snacks-terminal"),
    require("ui.snacks-notifier"),
    require("ui.snacks-toggle"),
    require("ui.snacks-bigfile")
  )
)

-- Navigation
require("navigation.flash")
require("navigation.mini-files")

-- UI
require("ui.which-key")
require("ui.statusline")
require("ui.noice")
require("ui.mini-starter")
require("ui.mini-icons")
require("ui.mini-indentscope")
require("ui.render-markdown")

-- Editing
require("editing.treesitter")
require("editing.blink")
require("editing.conform")
require("editing.multicursor")
require("editing.mini-surround")
require("editing.mini-pairs")
require("editing.mini-comment")
require("editing.mini-align")

-- Git
require("git.neogit")
require("git.gitsigns")
require("git.mini-diff")
require("git.codediff")

-- LSP
require("lsp.lsp")

-- AI
require("ai.claude")
