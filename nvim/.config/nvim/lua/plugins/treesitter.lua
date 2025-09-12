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
        select = { enable = false },
        lsp_interop = { enable = false },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>ao'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>ak'] = '@parameter.inner',
          },
        },
      },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
    opts = {
      max_lines = 3,
      trim_scope = 'outer',
      mode = 'cursor',
    },
    config = function(_, opts)
      require('treesitter-context').setup(opts)
      
      -- Set custom highlight for dim foreground instead of background
      vim.api.nvim_set_hl(0, 'TreesitterContext', { fg = '#666666', bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', { fg = '#444444', bg = 'NONE' })
    end,
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
