return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.1',
    lazy = false,
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>fp', '<cmd>Telescope find_files<CR>' },
    },
    config = require 'telescope.setup',
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build =
    'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
    config = function()
      require('telescope').load_extension('fzf')
    end
  },
}
