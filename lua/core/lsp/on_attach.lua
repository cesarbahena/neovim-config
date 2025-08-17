return function(_, bufnr)
  keymap {
    buffer = bufnr,

    -- Navigation (using existing keys)
    key { 'Code Definition', vim.lsp.buf.definition },
    key { 'Code Declaration', vim.lsp.buf.declaration },
    key { 'Code Type', vim.lsp.buf.type_definition },
    key { 'Code References', vim.lsp.buf.references },
    key { 'Code Implementation', vim.lsp.buf.implementation },

    -- Actions (using existing keys)
    key { 'code rename', vim.lsp.buf.rename },
    key { 'Code Suggestions', vim.lsp.buf.code_action },
    key { 'Code Format', vim.lsp.buf.format },

    -- Hover and signature
    key { 'hover', vim.lsp.buf.hover },
    key { 'signature', vim.lsp.buf.signature_help },
  }

  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
end
