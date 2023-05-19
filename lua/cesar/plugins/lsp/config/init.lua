-- local handlers = Plugin 'lsp.handlers'
-- Plugin 'lsp.inlay'

local custom_attach = Plugin 'lsp.config.on_attach'

local custom_init = function(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end

local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
vim.tbl_deep_extend("force", updated_capabilities, require("cmp_nvim_lsp").default_capabilities())
updated_capabilities.textDocument.completion.completionItem.snippetSupport = true
updated_capabilities.textDocument.completion.completionItem.insertReplaceSupport = false
-- updated_capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
-- updated_capabilities.textDocument.codeLens = { dynamicRegistration = false }

return function(server, config)
  if not config then
    return
  end

  if type(config) ~= "table" then
    config = {}
  end

  config = vim.tbl_deep_extend("force", {
    on_init = custom_init,
    on_attach = custom_attach,
    capabilities = updated_capabilities,
    flags = {
      debounce_text_changes = nil,
    },
  }, config)

  require 'lspconfig'[server].setup(config)
end
