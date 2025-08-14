return {
  {
    'rebelot/kanagawa.nvim',
    lazy = false,
    priority = 1000,
    init = function() vim.cmd 'colorscheme kanagawa' end,
    opts = {
      transparent = true,
    },
  },
  {
    'xiyaowong/transparent.nvim',
    opts = {
      extra_groups = {
        'NormalFloat',
        'FloatBorder',
        'SnacksPickerFile',
        'SnacksPickerDir',
        'SnacksPickerPrompt',
        'SnacksPickerList',
      },
    },
    config = function(_, opts)
      require('transparent').setup(opts)
      vim.cmd 'TransparentEnable'
    end,
  },
}
