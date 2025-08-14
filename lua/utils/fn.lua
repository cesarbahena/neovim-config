---@class FnModule
local M = {}

-- Helper Functions --

---Parse a module path string into module and function name
---@param module_path string The module.function path
---@return string|nil module_name The module name
---@return string|nil function_name The function name
---@return string|nil error_msg Error message if parsing fails
local function parse_module_path(module_path)
  local last_dot = module_path:match '.*()%.'
  if not last_dot then
    return nil, nil, 'Module path must include function name: "module.function", got "' .. module_path .. '"'
  end

  local module_name = module_path:sub(1, last_dot - 1)
  local function_name = module_path:sub(last_dot + 1)
  return module_name, function_name, nil
end

---Resolve a module path to the actual function
---@param module_path string The module.function path
---@return function|nil fn The resolved function
---@return string|nil error_msg Error message if resolution fails
local function resolve_module_function(module_path)
  local module_name, function_name, parse_error = parse_module_path(module_path)
  if parse_error then return nil, parse_error end

  local success, module = pcall(require, module_name)
  if not success then return nil, 'Module not found: ' .. module_name end

  local module_fn = module[function_name]
  if not module_fn then return nil, 'Function ' .. function_name .. ' not found in module ' .. module_name end

  return module_fn, nil
end

---Call a module function directly (without pcall)
---@param module_path string The module.function path
---@param args table Arguments to pass to the function
---@return any result The function result
local function call_module_function_direct(module_path, args)
  local module_name, function_name = parse_module_path(module_path)
  local module = require(module_name)
  return module[function_name](unpack(args))
end

---Call a module function with pcall
---@param module_path string The module.function path
---@param args table Arguments to pass to the function
---@return boolean success Whether the call succeeded
---@return any result The function result or error message
local function call_module_function_safe(module_path, args)
  return pcall(function() return call_module_function_direct(module_path, args) end)
end

---Merge function arguments with additional args
---@param fn_def table Function definition with arguments
---@param extra_args table Additional arguments to merge
---@return table merged_args The merged arguments
local function merge_function_args(fn_def, extra_args)
  local fn_args = {}

  -- Add function's own arguments
  for i = 2, #fn_def do
    table.insert(fn_args, fn_def[i])
  end

  -- Add extra arguments
  for i = 1, #extra_args do
    table.insert(fn_args, extra_args[i])
  end

  return fn_args
end

---Evaluate a condition (string, function, or boolean)
---@param condition any The condition to evaluate
---@return boolean result The evaluation result
local function evaluate_condition(condition)
  if type(condition) == 'string' then
    -- Lazy evaluation: execute the string as Lua code
    local func, err = load('return ' .. condition)
    if not func then return false end

    local success, result = pcall(func)
    return success and not not result
  elseif type(condition) == 'function' then
    -- Lazy evaluation: call the function
    local success, result = pcall(condition)
    return success and not not result
  elseif type(condition) == 'boolean' then
    -- Immediate evaluation
    return condition
  end

  return false
end

---Execute a function (table, string, or function) with appropriate handling
---@param target_fn any The function to execute
---@param args table Arguments to pass
---@param use_pcall boolean Whether to use pcall
---@param fn_resolver function The fn resolver function (for recursive calls)
---@return boolean success Whether the call succeeded (only relevant if use_pcall is true)
---@return any result The function result or error message
local function execute_function(target_fn, args, use_pcall, fn_resolver)
  if type(target_fn) == 'table' then
    local fn_args = merge_function_args(target_fn, args)

    if type(target_fn[1]) == 'string' then
      if use_pcall then
        return call_module_function_safe(target_fn[1], fn_args)
      else
        return true, call_module_function_direct(target_fn[1], fn_args)
      end
    else
      if use_pcall then
        return pcall(target_fn[1], unpack(fn_args))
      else
        return true, target_fn[1](unpack(fn_args))
      end
    end
  elseif type(target_fn) == 'string' then
    if use_pcall then
      return call_module_function_safe(target_fn, args)
    else
      return true, call_module_function_direct(target_fn, args)
    end
  elseif type(target_fn) == 'function' then
    if use_pcall then
      return pcall(target_fn, unpack(args))
    else
      return true, target_fn(unpack(args))
    end
  else
    -- Use fn_resolver for other cases
    if use_pcall then
      return pcall(function() return fn_resolver(target_fn, unpack(args))() end)
    else
      return true, fn_resolver(target_fn, unpack(args))()
    end
  end
end

-- Main API Functions --

---Handle conditional execution: { when = condition, [1] = fn, or_else = fn }
---@param spec table The conditional specification
---@param args table Arguments passed to the fn call
---@param fn_resolver function The fn resolver function
---@return function executable The executable function
local function handle_conditional(spec, args, fn_resolver)
  return function()
    local condition = spec['when']
    local condition_result = evaluate_condition(condition)

    local target_fn = condition_result and spec[1] or spec['or_else']
    if not target_fn then return nil end

    local success, result = execute_function(target_fn, args, false, fn_resolver)
    return result
  end
end

---Check if main function error should be notified
---@param notify_option string The notify option
---@return boolean should_notify Whether to notify main errors
local function should_notify_main_error(notify_option) return notify_option == 'main' or notify_option == 'both' end

---Check if fallback function should use pcall
---@param notify_option string The notify option
---@return boolean should_pcall Whether to use pcall for fallback
local function should_pcall_fallback(notify_option) return notify_option == 'fallback' or notify_option == 'both' end

---Handle try/notify execution: { [1] = fn, or_else = fn, notify = 'main'|'fallback'|'both' }
---@param spec table The try/notify specification
---@param args table Arguments passed to the fn call
---@param fn_resolver function The fn resolver function
---@return function executable The executable function
local function handle_try_notify(spec, args, fn_resolver)
  return function()
    local main_fn = spec[1]
    local notify_option = spec['notify'] or 'fallback'

    -- Validate notify option
    if notify_option ~= 'main' and notify_option ~= 'fallback' and notify_option ~= 'both' then
      error("Invalid notify option: '" .. tostring(notify_option) .. "'. Expected 'main', 'fallback', or 'both'")
    end

    -- Execute main function with pcall
    local success, result = execute_function(main_fn, args, true, fn_resolver)

    -- Early return on success
    if success then return result end

    -- Handle main function failure notification
    if should_notify_main_error(notify_option) then vim.notify(tostring(result), vim.log.levels.ERROR) end

    -- Execute or_else if available
    local or_else_fn = spec['or_else']
    if not or_else_fn then return nil end

    -- Determine execution strategy for or_else function
    local use_pcall_for_fallback = should_pcall_fallback(notify_option)

    if use_pcall_for_fallback then
      -- Use pcall and handle errors with notifications
      local or_else_success, or_else_result = execute_function(or_else_fn, args, true, fn_resolver)
      if not or_else_success then
        vim.notify(tostring(or_else_result), vim.log.levels.ERROR)
        return nil
      end
      return or_else_result
    else
      -- Call directly - let errors propagate naturally (for 'main' mode)
      if type(or_else_fn) == 'table' then
        local fn_args = merge_function_args(or_else_fn, args)
        if type(or_else_fn[1]) == 'string' then
          return call_module_function_direct(or_else_fn[1], fn_args)
        else
          return or_else_fn[1](unpack(fn_args))
        end
      elseif type(or_else_fn) == 'string' then
        return call_module_function_direct(or_else_fn, args)
      elseif type(or_else_fn) == 'function' then
        return or_else_fn(unpack(args))
      else
        error('Unsupported or_else type: ' .. type(or_else_fn))
      end
    end
  end
end

---Handle direct function execution with error handling
---@param func function The function to execute
---@param args table Arguments to pass to the function
---@return function executable The executable function
local function handle_direct_function(func, args)
  return function()
    local success, result = pcall(func, unpack(args))
    if not success then
      vim.notify(tostring(result), vim.log.levels.WARN)
      return nil
    end
    return result
  end
end

---Handle module path execution with error handling
---@param module_path string The module.function path
---@param args table Arguments to pass to the function
---@return function executable The executable function
local function handle_module_path(module_path, args)
  return function()
    local module_fn, error_msg = resolve_module_function(module_path)
    if error_msg then
      vim.notify(error_msg, vim.log.levels.ERROR)
      return nil
    end

    local success, result = pcall(module_fn, unpack(args))
    if not success then
      vim.notify(tostring(result), vim.log.levels.ERROR)
      return nil
    end

    return result
  end
end

-- Public API --

---Create a lazy function wrapper with conditional execution, error handling, and notifications
---
---## Usage Patterns:
---
---### 1. Conditional Execution
---```lua
---fn { when = condition, main_function, or_else = fallback_function }
---```
---
---### 2. Try/Notify with Error Handling
---```lua
---fn { main_function, or_else = fallback, notify = 'main'|'fallback'|'both' }
---```
---
---### 3. Direct Function Call
---```lua
---fn(function_reference, arg1, arg2, ...)
---```
---
---### 4. Module Path Call
---```lua
---fn('module.function_name', arg1, arg2, ...)
---```
---
---## Notify Options:
---
---• **'main'**: Only notify errors from the main function, or_else errors propagate
---• **'fallback'** (default): Only notify errors from the fallback function, main errors are silent
---• **'both'**: Notify errors from both main and fallback functions
---
---@param fn_or_module_path function|string|table The function, module path, or specification table
---@param ... any Arguments to pass to the function
---@return function lazy_function A function that executes the specified logic when called
function M.fn(fn_or_module_path, ...)
  local args = { ... }

  -- Guard clause: Handle table specifications
  if type(fn_or_module_path) == 'table' then
    -- Guard clause: Handle conditional execution
    if fn_or_module_path['when'] ~= nil and fn_or_module_path[1] then
      return handle_conditional(fn_or_module_path, args, M.fn)
    end

    -- Guard clause: Handle try/notify execution
    if fn_or_module_path[1] then return handle_try_notify(fn_or_module_path, args, M.fn) end

    error 'Invalid table format. Expected { when = condition, [1] = fn, or_else = fn } or { [1] = fn, or_else = fn }'
  end

  -- Guard clause: Handle direct function calls
  if type(fn_or_module_path) == 'function' then return handle_direct_function(fn_or_module_path, args) end

  -- Guard clause: Validate string input
  if type(fn_or_module_path) ~= 'string' then
    error('Expected function, string, or table, got ' .. type(fn_or_module_path))
  end

  -- Handle module path execution
  return handle_module_path(fn_or_module_path, args)
end

return M

