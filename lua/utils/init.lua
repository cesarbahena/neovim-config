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

function M.fn(fn_or_module_path, ...)
  -- Table case: conditional or try/catch
  if type(fn_or_module_path) == 'table' then
    local args = { ... }

    -- Conditional table: { when = condition, [1] = fn, or_else = fn }
    if fn_or_module_path['when'] ~= nil and fn_or_module_path[1] then
      return function()
        local condition = fn_or_module_path['when']
        local condition_result = false

        -- Evaluate condition
        if type(condition) == 'string' then
          -- Lazy evaluation: execute the string as Lua code
          local func, err = load('return ' .. condition)
          if func then
            local success, result = pcall(func)
            condition_result = success and not not result
          else
            condition_result = false
          end
        elseif type(condition) == 'function' then
          -- Lazy evaluation: call the function
          local success, result = pcall(condition)
          condition_result = success and not not result
        elseif type(condition) == 'boolean' then
          -- Immediate evaluation
          condition_result = condition
        end

        local target_fn = condition_result and fn_or_module_path[1] or fn_or_module_path['or_else']
        if not target_fn then return nil end

        -- Execute the selected function
        if type(target_fn) == 'table' then
          local fn_args = {}
          for i = 2, #target_fn do
            table.insert(fn_args, target_fn[i])
          end
          for i = 1, #args do
            table.insert(fn_args, args[i])
          end
          if type(target_fn[1]) == 'string' then
            return M.fn(target_fn[1], unpack(fn_args))()
          else
            return target_fn[1](unpack(fn_args))
          end
        else
          return M.fn(target_fn, unpack(args))()
        end
      end
    end

    -- Try/catch table: { [1] = fn, or_else = fn }
    if fn_or_module_path[1] then
      return function()
        local main_fn = fn_or_module_path[1]
        local success, result

        if type(main_fn) == 'table' then
          local fn_args = {}
          for i = 2, #main_fn do
            table.insert(fn_args, main_fn[i])
          end
          for i = 1, #args do
            table.insert(fn_args, args[i])
          end
          success, result = pcall(main_fn[1], unpack(fn_args))
        else
          success, result = pcall(function() return M.fn(main_fn, unpack(args))() end)
        end

        if success then
          return result
        elseif fn_or_module_path['or_else'] then
          local or_else_fn = fn_or_module_path['or_else']
          if type(or_else_fn) == 'table' then
            local fn_args = {}
            for i = 2, #or_else_fn do
              table.insert(fn_args, or_else_fn[i])
            end
            for i = 1, #args do
              table.insert(fn_args, args[i])
            end
            if type(or_else_fn[1]) == 'string' then
              return M.fn(or_else_fn[1], unpack(fn_args))()
            else
              return or_else_fn[1](unpack(fn_args))
            end
          else
            return M.fn(or_else_fn, unpack(args))()
          end
        else
          -- Show error as notification instead of throwing
          vim.notify(tostring(result), vim.log.levels.ERROR)
          return nil
        end
      end
    end

    error 'Invalid table format. Expected { when = condition, [1] = fn, or_else = fn } or { [1] = fn, or_else = fn }'
  end

  -- Direct function case: wrap it with args and error handling
  if type(fn_or_module_path) == 'function' then
    local args = { ... }
    return function() 
      local success, result = pcall(fn_or_module_path, unpack(args))
      if not success then
        vim.notify(tostring(result), vim.log.levels.WARN)
        return nil
      end
      return result
    end
  end

  -- Module.function path case
  if type(fn_or_module_path) ~= 'string' then
    error('Expected function, string, or table, got ' .. type(fn_or_module_path))
  end

  -- Parse module.function path
  local last_dot = fn_or_module_path:match '.*()%.'
  if not last_dot then
    error('Module path must include function name: "module.function", got "' .. fn_or_module_path .. '"')
  end

  local module_path = fn_or_module_path:sub(1, last_dot - 1)
  local function_name = fn_or_module_path:sub(last_dot + 1)
  local args = { ... }

  return function()
    local success, module = pcall(require, module_path)
    if not success then
      vim.notify('Module not found: ' .. module_path, vim.log.levels.ERROR)
      return nil
    end

    local module_fn = module[function_name]
    if not module_fn then 
      vim.notify('Function ' .. function_name .. ' not found in module ' .. module_path, vim.log.levels.ERROR)
      return nil
    end

    local fn_success, result = pcall(module_fn, unpack(args))
    if not fn_success then
      vim.notify(tostring(result), vim.log.levels.ERROR)
      return nil
    end

    return result
  end
end

return M
