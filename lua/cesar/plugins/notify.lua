return {
  {
    'rcarriga/nvim-notify',
    keys = {
      { '<leader>fn', '<cmd>Telescope notify<CR>', desc = 'Notifications' },
    },
    config = function ()
      require'notify'.setup()
      require('telescope').load_extension('notify')
    end,
  }
}
