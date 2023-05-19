return {
  Plugin 'ui.catppuccin',
  Plugin 'ui.devicons',
  Plugin 'ui.notify',
  {
    'lewis6991/gitsigns.nvim',
    config = Plugin 'ui.gitsigns',
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = Plugin 'ui.lualine.setup'
  },
  {
    'glepnir/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup {}
    end,
    dependencies = { { 'nvim-tree/nvim-web-devicons' } }
  }
}
