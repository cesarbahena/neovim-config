local M = {}

--[[General utils]]

-- Get (or create) global nested table from dot-separated path
function M.global(path)
  local current = _G
  for part in string.gmatch(path, '[^%.]+') do
    current[part] = current[part] or {}
    current = current[part]
  end
  return current
end

-- Helper for command strings with <CR>
function M.cmd(command) return '<cmd>' .. command .. '<cr>' end

-- Helper for vim.cmd.normal with bang
function M.bang(command)
  return function()
    vim.cmd.normal({ command, bang = true })
  end
end

-- Execute functions sequentially
function M.proc(funcs)
  for _, func in ipairs(funcs) do
    func()
  end
end

-- Import fn module
M.fn = require('utils.fn').fn

return M
