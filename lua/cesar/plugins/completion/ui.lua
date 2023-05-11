return {
  'onsails/lspkind-nvim',
  config = function ()
    require 'lspkind'.init {
      symbol_map = {
        Copilot = "",
      },
    }
    vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
    require 'cmp'.setup {
      formatting = {
        format = require 'lspkind'.cmp_format {
          with_text = true,
          menu = {
            buffer = "[buf]",
            nvim_lsp = "[LSP]",
            nvim_lua = "[api]",
            path = "[path]",
            luasnip = "[snip]",
          },
        },
      },
    }
  end,
}
