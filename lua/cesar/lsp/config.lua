local custom_attach = require(User .. ".lsp.on_attach")

local custom_init = function(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end

local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_ok, cmp = pcall(require, "cmp_nvim_lsp")
if cmp_ok then
  vim.tbl_deep_extend("force", updated_capabilities, cmp.default_capabilities())
end
updated_capabilities.textDocument.completion.completionItem.snippetSupport = true
updated_capabilities.textDocument.completion.completionItem.insertReplaceSupport = false

local function setup_server(server, config)
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

  require("lspconfig")[server].setup(config)
end

return {
  "neovim/nvim-lspconfig",
  dependencies = { "hrsh7th/cmp-nvim-lsp" },
  config = function()
    local servers = require(User .. ".lsp.servers")
    for server, config in pairs(servers) do
      setup_server(server, config)
    end

    require(User .. ".lsp.diagnostics")
    require(User .. ".lsp.handlers")
  end,
}
