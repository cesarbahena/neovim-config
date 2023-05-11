local lspconfig = vim.F.npcall(require, "lspconfig")
if not lspconfig then return end

local imap = require(vim.g.user..'.utils').imap
local nmap = require(vim.g.user..'.utils').nmap
local autocmd = require(vim.g.user..'.utils').autocmd
local autocmd_clear = vim.api.nvim_clear_autocmds
local telescope_mapper = require(vim.g.user..'.utils').tele_cmd
local handlers = require(vim.g.user..'.plugins.lsp.handlers')
local ts_util = require 'nvim-lsp-ts-utils'
-- local inlays = require(vim.g.user..'.plugins.lsp.inlay')

local custom_init = function(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end

local augroup_highlight = vim.api.nvim_create_augroup("custom-lsp-references", { clear = true })
local augroup_codelens = vim.api.nvim_create_augroup("custom-lsp-codelens", { clear = true })
local augroup_format = vim.api.nvim_create_augroup("custom-lsp-format", { clear = true })
local augroup_semantic = vim.api.nvim_create_augroup("custom-lsp-semantic", { clear = true })

local autocmd_format = function(async, filter)
  vim.api.nvim_clear_autocmds { buffer = 0, group = augroup_format }
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = 0,
    callback = function()
      vim.lsp.buf.format { async = async, filter = filter }
    end,
  })
end

local filetype_attach = setmetatable({
  clojure_lsp = function()
    autocmd_format(false)
  end,

  ruby = function()
    autocmd_format(false)
  end,

  go = function()
    autocmd_format(false)
  end,

  scss = function()
    autocmd_format(false)
  end,

  css = function()
    autocmd_format(false)
  end,

  rust = function()
    telescope_mapper("<space>wf", "lsp_workspace_symbols", {
      ignore_filename = true,
      query = "#",
    }, true)
    autocmd_format(false)
  end,

  racket = function()
    autocmd_format(false)
  end,

  typescript = function()
    autocmd_format(false, function(client)
      return client.name ~= "tsserver"
    end)
  end,

  javascript = function()
    autocmd_format(false)
      -- return client.name ~= "tsserver"
    -- end)
  end,

  python = function()
    autocmd_format(false)
  end,
}, {
  __index = function()
    return function() end
  end,
})

local buf_nnoremap = function(opts)
  if opts[3] == nil then
    opts[3] = {}
  end
  opts[3].buffer = 0
  nmap(opts)
end

local buf_inoremap = function(opts)
  if opts[3] == nil then
    opts[3] = {}
  end
  opts[3].buffer = 0
  imap(opts)
end

local custom_attach = function(client, bufnr)
  if client.name == "copilot" then
    return
  end

  local filetype = vim.api.nvim_buf_get_option(0, "filetype")

  buf_inoremap { "<c-s>", vim.lsp.buf.signature_help }

  buf_nnoremap { "<space>cr", vim.lsp.buf.rename }
  buf_nnoremap { "<space>ca", vim.lsp.buf.code_action }

  buf_nnoremap { "gd", vim.lsp.buf.definition }
  buf_nnoremap { "gD", vim.lsp.buf.declaration }
  buf_nnoremap { "gT", vim.lsp.buf.type_definition }
  buf_nnoremap { "?", vim.lsp.buf.hover, { desc = "lsp:hover" } }

  buf_nnoremap { "<space>gI", handlers.implementation }
  buf_nnoremap { "<space>lr", "<cmd>lua require('cesar.plugins.lsp.codelens').run()<CR>" }
  buf_nnoremap { "<space>rr", "LspRestart" }

  telescope_mapper("gr", "lsp_references", nil, true)
  telescope_mapper("gI", "lsp_implementations", nil, true)
  telescope_mapper("<space>wd", "lsp_document_symbols", { ignore_filename = true }, true)
  telescope_mapper("<space>ww", "lsp_dynamic_workspace_symbols", { ignore_filename = true }, true)

  vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlightProvider then
    autocmd_clear { group = augroup_highlight, buffer = bufnr }
    autocmd { "CursorHold", augroup_highlight, vim.lsp.buf.document_highlight, bufnr }
    autocmd { "CursorMoved", augroup_highlight, vim.lsp.buf.clear_references, bufnr }
  end

  if client.server_capabilities.codeLensProvider then
    autocmd_clear { group = augroup_codelens, buffer = bufnr }
    autocmd { "BufEnter", augroup_codelens, vim.lsp.codelens.refresh, bufnr, once = true }
    autocmd { { "BufWritePost", "CursorHold" }, augroup_codelens, vim.lsp.codelens.refresh, bufnr }
  end

  if filetype == "typescript" then
    client.server_capabilities.semanticTokensProvider = nil
  end

  -- Attach any filetype specific options to the client
  filetype_attach[filetype]()
end

local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
updated_capabilities.textDocument.completion.completionItem.snippetSupport = true
updated_capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

-- Completion configuration
vim.tbl_deep_extend("force", updated_capabilities, require("cmp_nvim_lsp").default_capabilities())
updated_capabilities.textDocument.completion.completionItem.insertReplaceSupport = false

updated_capabilities.textDocument.codeLens = { dynamicRegistration = false }

local rust_analyzer, rust_analyzer_cmd = nil, { "rustup", "run", "rust-analyzer" }
rust_analyzer = {
  cmd = rust_analyzer_cmd,
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy",
      },
    },
  },
}

local servers = {
  bashls = true,
  eslint = true,
  gdscript = true,
  graphql = true,
  html = true,
  pyright = true,
  vimls = true,
  yamlls = true,
  ocamllsp = true,
  clojure_lsp = true,
  jsonls = {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  },
  cmake = (1 == vim.fn.executable "cmake-language-server"),
  dartls = pcall(require, "flutter-tools"),
  clangd = {
    cmd = {
      "clangd",
      "--background-index",
      "--suggest-missing-includes",
      "--clang-tidy",
      "--header-insertion=iwyu",
    },
    init_options = {
      clangdFileStatus = true,
    },
  },
  svelte = true,
  omnisharp = {
    cmd = { vim.fn.expand "~/build/omnisharp/run", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
  },
  rust_analyzer = rust_analyzer,
  racket_langserver = true,
  cssls = true,
  perlnavigator = true,
  tsserver = {
    init_options = ts_util.init_options,
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
    on_attach = function(client)
      custom_attach(client)
      ts_util.setup { auto_inlay_hints = false }
      ts_util.setup_client(client)
    end,
  },
}

require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = { "lua_ls", "jsonls" },
}

local setup_server = function(server, config)
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

  lspconfig[server].setup(config)
end


require("lspconfig").lua_ls.setup {
  on_init = custom_init,
  on_attach = custom_attach,
  capabilities = updated_capabilities,
  settings = {
    Lua = { workspace = { checkThirdParty = false }, semantic = { enable = false } },
  },
}

for server, config in pairs(servers) do
  setup_server(server, config)
end

require("null-ls").setup {
  sources = {
    -- require("null-ls").builtins.formatting.stylua,
    require("null-ls").builtins.diagnostics.eslint,
    require("null-ls").builtins.formatting.prettier,
    -- require("null-ls").builtins.formatting.isort,
    -- require("null-ls").builtins.formatting.black,
  },
}
