return {
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {
      toggler = { line = "C", block = "gC" },
      opleader = { line = "c", block = "gc" },
      extra = { above = "cL", below = "cl", eol = "cc" },
      mappings = { basic = true, extra = true },
    },
  },
  {
    "Wansmer/treesj",
    opts = {
      use_default_keymaps = false,
    },
    keys = function(self)
      local mappings = {
        colemak = "<leader>j",
        qwerty = "<leader>m",
      }
      return {
        {
          desc = "Toggle split/join",
          mappings[Keyboard],
          require(self.name).toggle,
        },
      }
    end,
  },
  {
    "AndrewRadev/switch.vim",
    keys = {
      { desc = "Switch boolean", "-", "<Plug>(Switch)" },
    },
  },
}
