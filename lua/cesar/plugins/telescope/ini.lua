return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.1',
    lazy = false,
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>fp', '<cmd>Telescope find_files<CR>' },
    },
    config = function()
      require(vim.g.user..'.plugins.telescope.options')()
      require(vim.g.user..'.plugins.telescope.mappings').ui()
      require(vim.g.user..'.plugins.telescope.mappings').commands()
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
