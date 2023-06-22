return {
	{
    "jose-elias-alvarez/null-ls.nvim",
    opts = function ()
      local nls = require("null-ls").builtins
      return {
        sources = {
          nls.formatting.stylua,
          nls.diagnostics.eslint,
          nls.formatting.prettier.with({
            extra_args = {
              "--single-quote",
            },
          }),
        },
      }
    end
  },
  { "MunifTanjim/prettier.nvim", config = true },
}
