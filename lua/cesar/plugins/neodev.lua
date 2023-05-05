return {
  {
    "folke/neodev.nvim",
    dependencies = {
      'neovim/nvim-lspconfig',
    },
    config = function()
      require 'neodev'.setup{}

      local lspconfig = require('lspconfig')

      lspconfig.lua_ls.setup{
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace"
            }
          }
        }
      }
    end
  }
}
