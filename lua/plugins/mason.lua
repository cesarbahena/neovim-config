return {
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
        "ts_ls",
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
  }
} 
