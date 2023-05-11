return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.1',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>fp', '<cmd>Telescope find_files<CR>' },
    },
    config = true,
  },
}
