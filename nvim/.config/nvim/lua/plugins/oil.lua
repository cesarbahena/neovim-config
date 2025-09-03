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
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,
      is_always_hidden = function(name, _) return name:match '^%.git$' and true or false end,
    },
    keymaps = {
      q = { 'actions.close', mode = 'n', opts = { exit_if_last_buf = true } },
    },
  },
  keys = {
    key { 'parent directory', cmd 'Oil' },
  },
}
