local M = {}

--[[General utils]]

-- Get (or create) global nested table from dot-separated path
function M.global(path)
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
  -- Table case: conditional or try/catch
  if type(fn_or_module_path) == 'table' then
    local args = { ... }
    
    -- Conditional table: { cond = condition, [1] = fn, fallback = fn }
    if fn_or_module_path['cond'] and fn_or_module_path[1] then
      return function()
        local condition = fn_or_module_path['cond']
        local condition_result = false
        
        -- Evaluate condition
        if type(condition) == 'string' then
          -- Path to boolean value
          local current = _G
          for part in string.gmatch(condition, "[^%.]+") do
            current = current[part]
            if current == nil then
              condition_result = false
              break
            end
          end
          condition_result = not not current
        elseif type(condition) == 'boolean' then
          condition_result = condition
        end
        
        local target_fn = condition_result and fn_or_module_path[1] or fn_or_module_path['fallback']
        if not target_fn then
          return nil
        end
        
        -- Execute the selected function
        return M.fn(target_fn, unpack(args))()
      end
    end
    
    -- Try/catch table: { [1] = fn, fallback = fn }
    if fn_or_module_path[1] then
      return function()
        local success, result = pcall(function()
          return M.fn(fn_or_module_path[1], unpack(args))()
        end)
        
        if success then
          return result
        elseif fn_or_module_path['fallback'] then
          return M.fn(fn_or_module_path['fallback'], unpack(args))()
        else
          error(result)
        end
      end
    end
    
    error('Invalid table format. Expected { cond = condition, [1] = fn, fallback = fn } or { [1] = fn, fallback = fn }')
  end

  -- Direct function case: wrap it with args
  if type(fn_or_module_path) == 'function' then
    local args = { ... }
    return function()
      return fn_or_module_path(unpack(args))
    end
  end

  -- Module.function path case
  if type(fn_or_module_path) ~= 'string' then
    error('Expected function, string, or table, got ' .. type(fn_or_module_path))
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
