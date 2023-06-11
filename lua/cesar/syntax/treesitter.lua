return function()
  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      "javascript",
      "typescript",
      "lua",
      "vim",
      "python",
      "regex",
      "bash",
      "markdown",
      "markdown_inline",
    },
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        node_incremental = "v",
        scope_incremental = "C",
        node_decremental = "D",
      },
    },
    indent = {
      enable = true,
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["i="] = "@assignment.inner",
          ["a="] = "@assignment.outer",
          ["=m"] = "@assignment.lhs",
          ["=o"] = "@assignment.rhs",
          ["iA"] = "@attribute.inner",
          ["aA"] = "@attribute.outer",
          ["ib"] = "@block.inner",
          ["ab"] = "@block.outer",
          ["iF"] = "@call.inner",
          ["aF"] = "@call.outer",
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@conditional.outer",
          ["ic"] = "@conditional.inner",
          ["al"] = "@loop.outer",
          ["il"] = "@loop.inner",
        },
      },
    },
  })
end
