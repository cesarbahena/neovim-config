local M = {}

AutoFormatted = false

local mini_icons_available, mini_icons = pcall(require, 'mini.icons')
local lsp_icons = {}
if mini_icons_available then
  local servers = {
    lua_ls = 'lua',
    emmet_ls = 'xml',
    tsserver = 'typescript',
    ts_ls = 'typescript',
    html = 'html',
    cssls = 'css',
    pyright = 'python',
    jsonls = 'json',
    rust_analyzer = 'rust',
    clangd = 'c',
    bashls = 'sh',
    svelte = 'svelte',
    graphql = 'graphql',
  }
  for server, filetype in pairs(servers) do
    local icon, hl = mini_icons.get('filetype', filetype)
    lsp_icons[server] = icon
  end
end

for i = 1, 5, 1 do
  M['lsp_' .. i] = {
    function()
      local server = vim.lsp.get_active_clients()[i]
      local icon = lsp_icons[server.name]
      if icon then return icon .. '  ' .. server.name end
      return '  ' .. server.name
    end,

    cond = function()
      local server = vim.lsp.get_active_clients()[i]
      if not server then return end

      if server.name == 'null-ls' then return end

      local buffer = vim.api.nvim_get_current_buf()
      return server.attached_buffers[buffer]
    end,

    color = 'StatuslineNormal',
  }
end

M.lsp_error = {
  function()
    local servers = vim.lsp.get_active_clients()
    if #servers > 5 then return '...' end

    local buffer = vim.api.nvim_get_current_buf()
    for _, server in ipairs(servers) do
      if server.attached_buffers[buffer] then return '' end
    end

    return 'No LSP'
  end,

  cond = function()
    if vim.bo.ft == '' then return end

    local exclude = {
      netrw = true,
      TelescopePrompt = true,
      Trouble = true,
      lazy = true,
      fugitive = true,
      harpoon = true,
      lspinfo = true,
      ['null-ls-info'] = true,
    }
    return not exclude[vim.bo.ft]
  end,

  icon = ' ',
  color = 'StatuslineError',
}

M.plugins = {
  function()
    local plugins = require('lazy.core.config').plugins
    local total = 0
    local init = 0
    for _, plugin in pairs(plugins) do
      total = total + 1
      if plugin._.loaded ~= nil then init = init + 1 end
    end
    return init .. '/' .. total
  end,
  icon = ' ',
  color = function()
    local plugins = require('lazy.core.config').plugins
    local has_errors = require('lazy.core.plugin').has_errors

    for _, plugin in pairs(plugins) do
      if has_errors(plugin) then return 'StatuslineError' end
    end

    if require('lazy.status').has_updates() then return 'StatuslineOk' end

    return 'StatuslineNormal'
  end,
}

return M
