return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    keys = {
      {
        desc = "Move outside syntactical region",
        "<C-o>",
        "<Esc><cmd>normal vvv<cr>A",
        mode = "i",
      },
    },
    config = function(self, opts)
      require(self.name .. ".configs").setup(opts)
    end,
    opts = {
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
        swap = {
          enable = true,
          swap_next = {
            ["<C-h>"] = "@parameter.inner",
          },
          swap_previous = {
            ["<C-k>"] = "@parameter.inner",
          },
        },
        lsp_interop = {
          enable = true,
          floating_preview_opts = {
            border = "rounded",
          },
          peek_definition_code = {
            ["<C-f>"] = "@function.outer",
            ["<leader>dc"] = "@class.outer",
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VeryLazy",
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    opts = {
      char = "",
      show_current_context = true,
    },
  },
  {
    "nvim-treesitter/playground",
    cmd = {
      "TSPlaygroundToggle",
      "TSHighlightCapturesUnderCursor",
      "TSNodeUnderCursor",
    },
  },
}
