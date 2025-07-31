return {
  'stevearc/oil.nvim',
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  lazy = false,
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    columns = {
      "permissions",
      "icon",
    },
    watch_for_changes = false,
    keymaps = {
      ['<c-e>'] = { "actions.close", mode = 'n' },
      ['<c-y>'] = { 'actions.select', mode = 'n' },
      ['<cr>'] = ':',
    }
  },
  keys = {
    {'-', "<cmd>Oil<cr>",  desc = "Open parent directory"  }
  }
}
