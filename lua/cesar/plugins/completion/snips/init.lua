return {
  {
    "saadparwaiz1/cmp_luasnip",
    dependencies = { "L3MON4D3/LuaSnip" },
    config = function ()
      require 'cmp'.setup {
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
      }
      Plugin 'completion.snips.config'
    end,
  },
}
