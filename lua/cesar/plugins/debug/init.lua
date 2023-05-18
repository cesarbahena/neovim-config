return {
  {
    'mfussenegger/nvim-dap',
    keys = Plugin 'debug.mappings',
    dependencies = {
      Plugin 'debug.ui',
    },
  },
  Plugin 'debug.adapters.js',
}
