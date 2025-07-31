return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    keys = {
      {
        desc = "Move outside syntactical region",
        "<C-o>",
        "<Esc><cmd>normal vvv<cr>A",
        mode = "i",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
    opts = {
      indent = { enable = true },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          node_incremental = "v",
          scope_incremental = "U",
          node_decremental = "u",
        },
      },
      textobjects = {
        swap = {
          enable = true,
          swap_next = {
            ["<C-h>"] = "@parameter.inner",
          },
          swap_previous = {
            ["<C-k>"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          goto_next_start = {
            ["gnf"] = "@function.outer",
            ["gnc"] = "@class.outer",
            ["gna"] = "@parameter.inner",
          },
          goto_next_end = {
            ["gof"] = "@function.outer",
            ["goc"] = "@class.outer",
            ["goa"] = "@parameter.inner",
          },
          goto_previous_start = {
            ["gef"] = "@function.outer",
            ["gec"] = "@class.outer",
            ["gea"] = "@parameter.inner",
          },
          goto_previous_end = {
            ["gmf"] = "@function.outer",
            ["gmc"] = "@class.outer",
            ["gma"] = "@parameter.inner",
},
        },
        lsp_interop = {
          enable = true,
          floating_preview_opts = {
            border = "rounded",
          },
          peek_definition_code = {
            --[[ ["<C-f>"] = "@function.outer",
            ["<leader>dc"] = "@class.outer", ]]
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
  },
  {
    "nvim-treesitter/playground",
    cmd = {
      "TSPlaygroundToggle",
      "TSHighlightCapturesUnderCursor",
      "TSNodeUnderCursor",
    },
  },
  {
    'Wansmer/treesj',
    keys = {{'j', ':TSJToggle<cr>', desc = 'Toggle node under cursor'}},
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {},
  }
}
