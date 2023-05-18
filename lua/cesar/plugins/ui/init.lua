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
}
