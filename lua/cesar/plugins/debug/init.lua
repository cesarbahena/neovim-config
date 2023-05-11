return {
  {
    'mfussenegger/nvim-dap',
    keys = require(vim.g.user..'.plugins.debug.mappings'),
    dependencies = {
      { 'theHamsta/nvim-dap-virtual-text', config = true },
      require(vim.g.user..'.plugins.debug.ui'),
      require(vim.g.user..'.plugins.debug.telescope'),
      require(vim.g.user..'.plugins.debug.vscodejs'),
    },
  },
}
