-- Get capabilities from blink
local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
local blink_ok, blink = pcall(require, 'blink.cmp')
if blink_ok then
  updated_capabilities = vim.tbl_deep_extend('force', updated_capabilities, blink.get_lsp_capabilities())
end
updated_capabilities.textDocument.completion.completionItem.snippetSupport = true
updated_capabilities.textDocument.completion.completionItem.insertReplaceSupport = false

-- Global LSP configuration
vim.lsp.config('*', {
  capabilities = updated_capabilities,
  flags = {
    allow_incremental_sync = true,
    debounce_text_changes = 150,
  },
})

-- Enable servers (configs will be loaded from lsp/ directory automatically)
local servers = {
  'lua_ls',
  'ts_ls',
  'pyright',
  'jsonls',
  'yamlls',
  'taplo',
  'marksman',
}

for _, server in ipairs(servers) do
  vim.lsp.enable(server)
end

-- Load diagnostics
require 'core.lsp.diagnostics'

-- Set up keymaps and autocommands
local custom_attach = require 'core.lsp.on_attach'

autocmd {
  'LspAttach',
  'LanguageServer',
  function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then custom_attach(client, args.buf) end
  end,
}

