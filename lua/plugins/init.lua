return {
  'nvim-lua/plenary.nvim',
  {
    'folke/which-key.nvim',
    lazy = true,
    config = function()
      require('which-key').add {
        {},
      }
    end,
  },
}
