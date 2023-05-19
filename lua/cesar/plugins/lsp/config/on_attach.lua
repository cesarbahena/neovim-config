local autocmd = require(User .. '.utils').autocmd
local autocmd_clear = vim.api.nvim_clear_autocmds
local telescope_mapper = require(User .. '.utils').tele_cmd

local augroup_highlight = vim.api.nvim_create_augroup("custom-lsp-references", { clear = true })
local augroup_codelens = vim.api.nvim_create_augroup("custom-lsp-codelens", { clear = true })

local nmap = function(opts)
  if opts[3] == nil then
    opts[3] = {}
  end
  opts[3].buffer = 0
  vim.keymap.set('n', opts[1], opts[2], opts[3])
end

local imap = function(opts)
  if opts[3] == nil then
    opts[3] = {}
  end
  opts[3].buffer = 0
  vim.keymap.set('i', opts[1], opts[2], opts[3])
end


return function(client, bufnr)
  if client.name == "copilot" then
    return
  end

  imap { "<C-s>", vim.lsp.buf.signature_help }
  nmap { "<space>cr", vim.lsp.buf.rename }
  nmap { "<space>ca", vim.lsp.buf.code_action }
  nmap { "gd", vim.lsp.buf.definition }
  nmap { "gD", vim.lsp.buf.declaration }
  nmap { "gT", vim.lsp.buf.type_definition }
  nmap { "?", vim.lsp.buf.hover, { desc = "lsp:hover" } }
  -- buf_nnoremap { "<space>gI", handlers.implementation }
  nmap { "<space>lr", "<cmd>lua require('cesar.plugins.lsp.codelens').run()<CR>" }
  nmap { "<space>rr", "<cmd>LspRestart<CR>" }

  -- telescope_mapper("gr", "lsp_references", nil, true)
  -- telescope_mapper("gI", "lsp_implementations", nil, true)
  -- telescope_mapper("<space>wd", "lsp_document_symbols", { ignore_filename = true }, true)
  -- telescope_mapper("<space>ww", "lsp_dynamic_workspace_symbols", { ignore_filename = true }, true)

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

  if vim.bo.ft == "typescript" then
    client.server_capabilities.semanticTokensProvider = nil
  end

  -- Attach any filetype specific options to the client
  Plugin 'lsp.config.on_filetype'[vim.bo.ft]()
  vim.notify(vim.bo.ft)
end
