return {
  {
    'aserowy/tmux.nvim',
    keys = {
      key { 'left window', fn 'tmux.move_left' },
      key { 'right window', fn 'tmux.move_right' },
      key { 'top window', fn 'tmux.move_top' },
      key { 'bottom window', fn 'tmux.move_bottom' },
      key { 'resize left', fn 'tmux.resize_left' },
      key { 'resize right', fn 'tmux.resize_right' },
      key { 'resize top', fn 'tmux.resize_top' },
      key { 'resize botom', fn 'tmux.resize_bottom' },
    },
    opts = {
      copy_sync = {
        enable = false,
      },
      navigation = {
        enable_default_keybindings = false,
        cycle_navigation = false,
      },
      resize = {
        enable_default_keybindings = false,
        resize_step_x = 5,
        resize_step_y = 5,
      },
    },
  },
}
