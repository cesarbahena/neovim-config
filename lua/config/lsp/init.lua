-- LSP Configuration using native vim.lsp API
local M = {}

function M.setup()
  -- Get capabilities from blink
  local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
  local blink_ok, blink = pcall(require, "blink.cmp")
  if blink_ok then
    updated_capabilities = vim.tbl_deep_extend("force", updated_capabilities, blink.get_lsp_capabilities())
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

  -- Load server configurations
  local servers = {
    'lua_ls', 'ts_ls', 'pyright', 'jsonls'
  }

  for _, server in ipairs(servers) do
    local server_config = try(require, "lsp." .. server):catch('ServerConfigNotFound')({})

    vim.lsp.config[server] = vim.tbl_deep_extend("force", {
      capabilities = updated_capabilities,
    }, server_config)
  end

  -- Load diagnostics
  require("config.lsp.diagnostics")

  -- Set up keymaps and autocommands
  local custom_attach = require("config.lsp.on_attach")

  autocmd {
    'LspAttach',
    'LanguageServer',
    function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then
        custom_attach(client, args.buf)
      end
    end,
  }
end

return M