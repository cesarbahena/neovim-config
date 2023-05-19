return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      local servers = Plugin 'lsp.config.servers'
      for server, config in pairs(servers) do
        Plugin 'lsp.config' (server, config)
      end
      Plugin 'lsp.diagnostics' ()
    end
  },

  { 'williamboman/mason.nvim', config = true },
  {
    'williamboman/mason-lspconfig.nvim',
    opts = {
      ensure_installed = { "lua_ls", "tsserver", "jsonls" },
    },
  },
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
  {
    'jose-elias-alvarez/null-ls.nvim',
    config = Plugin 'lsp.null_ls'
  },
  'jose-elias-alvarez/nvim-lsp-ts-utils',
  'MunifTanjim/prettier.nvim',
  "b0o/schemastore.nvim",
}
