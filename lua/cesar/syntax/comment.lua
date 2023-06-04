return {
  "numToStr/Comment.nvim",
  config = function()
    require("Comment").setup({
      toggler = {
        line = "C",
        block = "gC",
      },
      opleader = {
        line = "c",
        block = "gc",
      },
      extra = {
        above = "cL",
        below = "cl",
        eol = "ca",
      },
      mappings = {
        basic = true,
        extra = true,
      },
    })

    local keymap = require(User .. ".config.mappings")
    keymap({
      n = {
        { "Comment toggler operator", "cc", "c$", { remap = true } },
      },
    })
  end,
}
