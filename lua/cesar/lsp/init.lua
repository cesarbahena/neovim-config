return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local servers = require(User .. ".lsp.servers")
      for server, config in pairs(servers) do require(User .. ".lsp.config")(server, config) end
      require(User .. ".lsp.diagnostics")()
    end,
  },

  {
    "williamboman/mason.nvim",
    config = true,
    build = ":MasonUpdate",
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
        "tsserver",
        "jsonls",
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      auto_update = true,
      debounce_hours = 24,
      ensure_installed = {
        "stylua",
      },
    },
  },

  require(User .. ".lsp.inlay"),
  "folke/neodev.nvim",
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = require(User .. ".lsp.null_ls"),
  },
  "jose-elias-alvarez/nvim-lsp-ts-utils",
  {
    "MunifTanjim/prettier.nvim",
    config = true,
  },
  "b0o/schemastore.nvim",
}
