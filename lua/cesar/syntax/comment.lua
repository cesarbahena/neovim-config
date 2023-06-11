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

    local keymaps = require(User .. ".config.keymaps")
    keymaps({
      n = {
        { "Comment toggler operator", "cc", "c$", { remap = true } },
      },
    })
  end,
}
