return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      require(vim.g.user..'.plugins.lsp.config')
    end,
  },

  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      require("mason-tool-installer").setup {
        auto_update = true,
        debounce_hours = 24,
        ensure_installed = {
          "black",
        },
      }
    end,
  },

  require(vim.g.user..'.plugins.lsp.inlay'),
  'j-hui/fidget.nvim',
  'folke/neodev.nvim',
  'jose-elias-alvarez/null-ls.nvim',
  'jose-elias-alvarez/nvim-lsp-ts-utils',
  'MunifTanjim/prettier.nvim',
  "b0o/schemastore.nvim",
}



