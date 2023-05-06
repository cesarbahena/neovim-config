return {
  {
    'mfussenegger/nvim-dap',
    keys = require(vim.g.user..'.plugins.dap.mappings'),
    dependencies = {
      { 'theHamsta/nvim-dap-virtual-text', config = true },
      require(vim.g.user..'.plugins.dap.ui'),
      require(vim.g.user..'.plugins.dap.telescope'),
      require(vim.g.user..'.plugins.dap.vscodejs'),
    },
  },
}
