return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    config = function(_, opts) require('nvim-treesitter.configs').setup(opts) end,
    opts = {
      indent = { enable = true },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = false,
          node_incremental = 'v',
          node_decremental = 'u',
          scope_incremental = false,
        },
      },
      textobjects = {
        swap = {
          enable = true,
          swap_next = {
            ['<m-o>'] = '@parameter.inner',
          },
          swap_previous = {
            ['<m-h>'] = '@parameter.inner',
          },
        },
        lsp_interop = {
          enable = true,
          floating_preview_opts = {
            border = 'rounded',
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
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
  },
  {
    'nvim-treesitter/playground',
    cmd = {
      'TSPlaygroundToggle',
      'TSHighlightCapturesUnderCursor',
      'TSNodeUnderCursor',
    },
  },
  {
    'Wansmer/treesj',
    keys = { { 'j', ':TSJToggle<cr>', desc = 'Toggle node under cursor' } },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {},
  },
}
