return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.1',
    lazy = false,
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>fp', '<cmd>Telescope find_files<CR>' },
    },
    opts = require(vim.g.user..'.plugins.telescope.options'),
    config = function(_, opts)
      require'telescope'.setup(opts)
      require(vim.g.user..'.plugins.telescope.mappings')()
    end,
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
