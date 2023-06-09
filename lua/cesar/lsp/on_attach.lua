return function(client, bufnr)
  local keymaps = require(User .. ".config.keymaps")
  local autocmd = require(User .. ".config.autocmd")
  local telescope = function(picker)
    return string.format([[<cmd>lua require(User .. ".nav.pickers")("%s", "wide")()<CR>]], picker)
  end

  local excluded = {
    fugitive = true,
    copilot = true,
  }
  if excluded[vim.bo.ft] then
    return
  end

  if excluded[client.name] then
    return
  end

  keymaps({
    n = {
      { "Go to definition",       "gd",         vim.lsp.buf.definition },
      { "Go to declaration",      "gD",         vim.lsp.buf.declaration },
      { "Go to type definition",  "gT",         vim.lsp.buf.type_definition },
      { "Go to references",       "gr",         "<cmd>TroubleToggle lsp_references<CR>" },
      { "Go to implementations",  "gI",         telescope("lsp_implementations") },
      { "Find docunment symbols", "<leader>fs", telescope("lsp_document_symbols") },
      { "Find docunment symbols", "<leader>fd", telescope("lsp_dynamic_workspace_symbols") },
      { "Code rename",            "<leader>rs", vim.lsp.buf.rename },
      { "Code actions",           "<leader>ca", vim.lsp.buf.code_action },
      { "Format",                 "<leader>F",  vim.lsp.buf.format },
      { "Show hover help",        "?",          vim.lsp.buf.hover },
    },
    i = { { "Show signature help", "<C-f>", vim.lsp.buf.signature_help } },
  }, { buffer = true })

  vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlightProvider then
    autocmd({
      "CursorHold",
      "CustomLspReferences",
      vim.lsp.buf.document_highlight,
      bufnr,
      clear = false,
    })
    autocmd({
      "CursorMoved",
      "CustomLspReferences",
      vim.lsp.buf.clear_references,
      bufnr,
      clear = false,
    })
  end

  -- Attach any filetype specific options to the client
  require(User .. ".lsp.filetype")[vim.bo.ft]()
end
