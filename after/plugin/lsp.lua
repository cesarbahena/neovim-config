local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
  'tsserver',
  'rust_analyzer',
  'lua_ls',
})
-- Fix Undefined global 'vim'
lsp.configure('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
})


local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
  ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
  ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
  -- ["<C-i>"] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil
cmp_mappings['<C-e>'] = nil

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.set_preferences({
  suggest_lsp_servers = true,
  sign_icons = {
    error = 'E',
    warn = 'W',
    hint = 'H',
    info = 'I'
  }
})

lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }
  lsp.default_keymaps({ buffer = bufnr })
  lsp.buffer_autoformat()

  vim.keymap.set("n", "H", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "gt", function() vim.lsp.buf.type_definition() end, opts)
  vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
  vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>r", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("n", "<leader>s", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>d", "<cmd>Telescope diagnostics<cr>", opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
end)

lsp.format_on_save({
  format_opts = {
    timeout_ms = 10000,
  },
  servers = {
    ['null-ls'] = { 'javascript', 'typescript' },
  }
})

lsp.setup()

vim.diagnostic.config({
  virtual_text = true
})

local null_ls = require('null-ls')

null_ls.setup({
  sources = {
    -- Replace these with the tools you have installed
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.diagnostics.eslint,
  }
})
