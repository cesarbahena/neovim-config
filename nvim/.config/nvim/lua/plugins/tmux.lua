return {
  {
    'aserowy/tmux.nvim',
    keys = {
      motion { 'left window', fn 'tmux.move_left' },
      motion { 'right window', fn 'tmux.move_right' },
      motion { 'top window', fn 'tmux.move_top' },
      motion { 'botom window', fn 'tmux.move_bottom' },
      motion { 'resize left', fn 'tmux.resize_left' },
      motion { 'resize right', fn 'tmux.resize_right' },
      motion { 'resize top', fn 'tmux.resize_top' },
      motion { 'resize botom', fn 'tmux.resize_bottom' },
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
