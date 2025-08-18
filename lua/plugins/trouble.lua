return {
  {
    'folke/trouble.nvim',
    cmd = { 'Trouble' },
    opts = {
      modes = {
        lsp = {
          win = { position = 'right' },
        },
      },
    },
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>cs', '<cmd>Trouble symbols toggle<cr>', desc = 'Symbols (Trouble)' },
      { '<leader>cS', '<cmd>Trouble lsp toggle<cr>', desc = 'LSP references/definitions/... (Trouble)' },
      key { 'quiCkfiX list', cmd 'Trouble qflist toggle' },
      key {
        'Prev dx',
        fn {
          { 'trouble.prev', { skip_groups = true, jump = true } },
          when = fn 'trouble.is_open',
          or_else = proc {
            fn('trouble.open', 'diagnostics'),
            fn('trouble.prev', { skip_groups = true, jump = true }),
          },
        },
      },
      key {
        'Next dx',
        fn {
          { 'trouble.next', { skip_groups = true, jump = true } },
          when = fn 'trouble.is_open',
          or_else = proc {
            fn('trouble.open', 'diagnostics'),
            fn('trouble.next', { skip_groups = true, jump = true }),
          },
        },
      },
      key {
        'clean',
        fn {
          'trouble.close',
          when = fn 'trouble.is_open',
        },
      },
    },
  },
}
