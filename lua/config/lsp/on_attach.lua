return function(_, bufnr)
  local function map(spec)
    spec.buffer = bufnr
    keymap(normal(spec))
  end

  -- Navigation (using existing keys)
  map { 'Yes', vim.lsp.buf.definition, details = ', go to definition' }
  map { 'Go to Declaration', vim.lsp.buf.declaration }
  map { 'Go to Type', vim.lsp.buf.type_definition }
  map { 'Go to References', vim.lsp.buf.references }
  map { 'Go to Implementation', vim.lsp.buf.implementation }

  -- Actions (using existing keys)
  map { 'Code Rename', vim.lsp.buf.rename }
  map { 'Code Suggestions', vim.lsp.buf.code_action }
  map { 'Code Format', vim.lsp.buf.format }

  -- Hover and signature
  map { 'Code Definition', vim.lsp.buf.hover }
  map { 'Signature', vim.lsp.buf.signature_help }

  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
end
