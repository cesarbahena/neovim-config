return function(_, bufnr)
  keymap {
    bufnr = bufnr,

    -- Navigation (using existing keys)
    key { 'Yes', vim.lsp.buf.definition, details = ', go to definition' },
    key { 'Go to Declaration', vim.lsp.buf.declaration },
    key { 'Go to Type', vim.lsp.buf.type_definition },
    key { 'Go to References', vim.lsp.buf.references },
    key { 'Go to Implementation', vim.lsp.buf.implementation },

    -- Actions (using existing keys)
    key { 'Code Rename', vim.lsp.buf.rename },
    key { 'Code Suggestions', vim.lsp.buf.code_action },
    key { 'Code Format', vim.lsp.buf.format },

    -- Hover and signature
    key { 'Code Definition', vim.lsp.buf.hover },
    key { 'Signature', vim.lsp.buf.signature_help },
  }

  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
end
