local M = {}

local function get_source(index)
  return require("null-ls.sources").get_available(vim.bo.ft)[index]
end

local function is_executable(index)
  return require("null-ls.utils").is_executable(get_source(index).name)
end

local icons = {
  eslint = "",
  prettier = "",
  stylua = "",
}

for i = 1, 3, 1 do
  M["non_lsp_" .. i] = {
    function()
      local icon = icons[get_source(i).name]
      if icon then
        return icon .. "  " .. get_source(i).name
      end
      return get_source(i).name
    end,

    cond = function()
      return get_source(i) ~= nil
    end,

    color = function()
      local source = get_source(i)
      if not source then
        return
      end

      if source.can_run then
        if source.can_run() then
          return "Normal"
        else
          return "StatuslineError"
        end
      end

      if is_executable(i) then
        return "Normal"
      end

      local opts = source.generator.opts or {}
      if opts.only_local or opts.prefer_local then
        return "Normal"
      end

      return "StatuslineError"
    end,
  }
end

for i = 1, 10, 1 do
  M["lsp_" .. i] = {
    function()
      return vim.lsp.get_active_clients()[i].name
    end,

    cond = function()
      local buffer = vim.api.nvim_get_current_buf()
      local server = vim.lsp.get_active_clients()[i]
      if not server then
        return
      end
      if server.name == "null-ls" then
        return
      end
      return server.attached_buffers[buffer]
    end,

    icon = " ",
  }
end

M.no_lsp = {
  function()
    local buffer = vim.api.nvim_get_current_buf()
    local servers = vim.lsp.get_active_clients()
    if #servers > 10 then
      return "..."
    end
    for _, server in ipairs(servers) do
      if server.attached_buffers[buffer] then
        return ""
      end
    end
    return "No LSP"
  end,
  icon = " ",
  color = "StatuslineError",
}

return M
