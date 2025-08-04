local M = {}

--[[General utils]]

-- Get (or create) global nested table from dot-separated path
function M.get_or_create(path)
  local current = _G
  for part in string.gmatch(path, "[^%.]+") do
    current[part] = current[part] or {}
    current = current[part]
  end
  return current
end

-- Helper for command strings with <CR>
function M.cmd(command)
  return '<cmd>' .. command .. "<cr>"
end

function M.fn(fn_or_module_path, ...)
  -- Direct function case: wrap it with args
  if type(fn_or_module_path) == 'function' then
    local args = { ... }
    return function()
      return fn_or_module_path(unpack(args))
    end
  end

  -- Module.function path case
  if type(fn_or_module_path) ~= 'string' then
    error('Expected function or string, got ' .. type(fn_or_module_path))
  end

  -- Parse module.function path
  local last_dot = fn_or_module_path:match('.*()%.')
  if not last_dot then
    error('Module path must include function name: "module.function", got "' .. fn_or_module_path .. '"')
  end

  local module_path = fn_or_module_path:sub(1, last_dot - 1)
  local function_name = fn_or_module_path:sub(last_dot + 1)
  local args = { ... }
  
  return function()
    local module = require(module_path)
    local module_fn = module[function_name]
    
    if not module_fn then
      error('Function ' .. function_name .. ' not found in module ' .. module_path)
    end
    
    return module_fn(unpack(args))
  end
end

return M
