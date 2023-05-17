return {
  {
    'mfussenegger/nvim-dap',
    keys = require(vim.g.user..'.plugins.debug.mappings'),
    dependencies = {
      require('debug.ui'),
    },
  },
  require('debug.adapters.js'),
}
