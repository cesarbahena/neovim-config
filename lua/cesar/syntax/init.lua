return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    commit = "aa44e5f", -- Workaround for a bug
    config = require(User .. ".syntax.treesitter"),
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
  },
  "nvim-treesitter/nvim-treesitter-context",
  "nvim-treesitter/playground",
  "tpope/vim-surround",
  "tpope/vim-repeat",
  { "windwp/nvim-autopairs", config = true },
  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesj").setup({
        use_default_keymaps = true,
      })
      local keymaps = require(User .. ".config.keymaps")
      keymaps({
        [""] = {
          { "Toggle split/join", "<leader>j", require("treesj").toggle },
        },
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      char = "",
      show_current_context = true,
    },
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    dependencies = {
      "axieax/urlview.nvim",
    },
    config = require(User .. ".syntax.various_textobjs"),
  },
  require(User .. ".syntax.comment"),
  require(User .. ".syntax.mini_ai"),
}
