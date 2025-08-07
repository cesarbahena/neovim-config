return {
  'stevearc/oil.nvim',
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  lazy = false,
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    columns = {
      'permissions',
      'icon',
    },
    watch_for_changes = false,
    keymaps = {
      ['<c-u>'] = { 'actions.close', mode = 'n', opts = { exit_if_last_buf = true } },
      ['<c-y>'] = { 'actions.select', mode = 'n' },
      ['<cr>'] = ':',
    },
  },
  keys = {
    { '-', '<cmd>Oil<cr>', desc = 'Open parent directory' },
  },
}
