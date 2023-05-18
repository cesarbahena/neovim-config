return {
  {
    'neovim/nvim-lspconfig',
    config = Plugin 'lsp.setup',
  },

  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      auto_update = true,
      debounce_hours = 24,
      ensure_installed = {},
    }
  },

  Plugin 'lsp.inlay',
  'j-hui/fidget.nvim',
  'folke/neodev.nvim',
  'jose-elias-alvarez/null-ls.nvim',
  'jose-elias-alvarez/nvim-lsp-ts-utils',
  'MunifTanjim/prettier.nvim',
  "b0o/schemastore.nvim",
}



