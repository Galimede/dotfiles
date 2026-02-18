local starter = require("mini.starter")

starter.setup({
  evaluate_single = true,
  items = {
    starter.sections.sessions(5, true),
    starter.sections.recent_files(10, false),
    starter.sections.builtin_actions(),
  },
  header = table.concat({
    "███╗   ██╗██╗   ██╗██╗███╗   ███╗",
    "████╗  ██║██║   ██║██║████╗ ████║",
    "██╔██╗ ██║██║   ██║██║██╔████╔██║",
    "██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
    "██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
    "╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
  }, "\n"),
  footer = "",
})
