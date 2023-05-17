return {
  {
    "AckslD/nvim-neoclip.lua",
    keys = {
      { '<leader>p', '<cmd>Telescope neoclip<CR>', desc = 'Clipboard' }
    },
    config = function ()
      require 'neoclip'.setup()
      require 'telescope'.load_extension 'neoclip'
    end,
  },
}
