return {
  {
    'aserowy/tmux.nvim',
    keys = {
      { desc = 'Navigate to window/tmux pane to the left', '<C-k>', fn 'tmux.move_left' },
      { desc = 'Navigate to window/tmux pane below', '<C-n>', fn 'tmux.move_bottom' },
      { desc = 'Navigate to window/tmux pane above', '<C-e>', fn 'tmux.move_top' },
      { desc = 'Navigate to window/tmux pane to the right', '<C-h>', fn 'tmux.move_right' },
      { desc = 'Resize window/tmux pane left', '<C-M-k>', fn 'tmux.resize_left' },
      { desc = 'Resize window/tmux pane down', '<C-M-n>', fn 'tmux.resize_bottom' },
      { desc = 'Resize window/tmux pane up', '<C-M-e>', fn 'tmux.resize_top' },
      { desc = 'Resize window/tmux pane right', '<C-M-h>', fn 'tmux.resize_right' },
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
