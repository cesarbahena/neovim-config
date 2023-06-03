local M = {}

M.linters = {
  function()
    local get_servers = function(filetype, service_type)
      return require("null-ls.sources").get_available(filetype, service_type)
    end
    local formatters = get_servers(vim.bo.ft, "NULL_LS_DIAGNOSTICS")
    local output = ""
    for i, _ in ipairs(formatters) do
      pcall(function()
        output = output .. " " .. formatters[i].name
      end)
    end
    return output
  end,
}

M.formatters = {
  function()
    local get_servers = function(filetype, service_type)
      return require("null-ls.sources").get_available(filetype, service_type)
    end
    local formatters = get_servers(vim.bo.ft, "NULL_LS_FORMATTING")
    local output = ""
    for i, _ in ipairs(formatters) do
      pcall(function()
        output = output .. " " .. formatters[i].name
      end)
    end
    return output
  end,
}

M.lsp = {
  function()
    local buffer = vim.api.nvim_get_current_buf()
    local servers = vim.lsp.get_active_clients()
    local output = ""
    for i, _ in ipairs(servers) do
      pcall(function()
        if servers[i].config.capabilities and servers[i].attached_buffers[buffer] then
          output = output .. "   " .. servers[i].name
        end
      end)
    end
    return output
  end,
  padding = { left = 0 },
}

M.lsp2 = {
  function()
    local msg = "No LSP"
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
      return msg
    end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, vim.bo.ft) ~= -1 then
        return client.name
      end
    end
    return msg
  end,
  icon = " ",
}

return M
