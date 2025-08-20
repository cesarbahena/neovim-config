return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  opts = {
    modes = {
      char = {
        enabled = true,
        keys = { 't', 'T' },
      },
      search = {
        enabled = true,
      },
      treesitter = {
        labels = 'NEIOH"MKARST',
        jump = { autojump = false },
      },
    },
  },
  keys = {
    key { 'Remote', fn 'flash.remote', mode = 'o' },
    key {
      'Visual mode',
      function()
        vim.cmd 'normal! v'
        require('flash').treesitter()
      end,
      details = '(TS enhanced)',
    },
  },
  config = function(_, opts)
    require('flash').setup(opts)

    -- Override flash's t/T mappings with our smart functions
    keymap {
      key { 'To', fn 'actions.to' },
      key { 'back To', fn 'actions.back_to' },
    }
  end,
}
