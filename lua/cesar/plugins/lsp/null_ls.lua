return function()
  require("null-ls").setup {
    sources = {
      -- require("null-ls").builtins.formatting.stylua,
      require("null-ls").builtins.diagnostics.eslint,
      require("null-ls").builtins.formatting.prettier,
      -- require("null-ls").builtins.formatting.isort,
      -- require("null-ls").builtins.formatting.black,
    },
  }
end
