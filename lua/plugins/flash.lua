local spec_gen = require 'utils.keymap_spec_generator'
local motion = spec_gen.motion
local operator = spec_gen.operator

local fn = require('utils').fn

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
        labels = '123456789',
        jump = { autojump = false },
      },
    },
  },
  keys = {
    motion { 'Find in screen', fn 'flash.jump' },
    pending { 'Remote', fn 'flash.remote' },
    -- operator { 'Till', fn ('flash.jump', { mode = 'char' }) },
    -- normal { 'Treesitter search', fn 'flash.treesitter_search' },
    normal {
      'Visual mode',
      function()
        vim.cmd 'normal! v'
        require('flash').treesitter()
      end,
      details = '(TS enhanced)',
    },
  },
}
