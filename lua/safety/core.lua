-- Core Safety System - Built around your friend's brilliant try function
local M = {}

-- Initialize safety state
_G.SAFETY = _G.SAFETY or {
  mode = 'normal',        -- 'normal', 'backup', 'emergency'
  initialized = false,
  summary_shown = false,
  backup_active = false,
}

-- Get all errors from try function's error storage (your friend's design)
function M.get_all_errors()
  local all_errors = {}
  local seen = {} -- Deduplicate
  
  for category, errors in pairs(_G.Errors or {}) do
    for _, error in ipairs(errors) do
      local key = error.module .. ':' .. error.message
      if not seen[key] then
        seen[key] = true
        table.insert(all_errors, {
          category = category,
          module = error.module,
          message = error.message,
          line = error.line,
          severity = error.category == 'syntax_error' and 'CRITICAL' or 'ERROR',
          timestamp = error.time,
          traceback = error.traceback,
        })
      end
    end
  end
  return all_errors
end

-- Safe require using try function at its core
function M.safe_require(module, options)
  options = options or {}
  local required = options.required or false
  local category = options.category or (required and 'CriticalErrors' or 'OptionalErrors')
  
  -- Use your friend's try function
  local result = try(require, module):catch(category)
  
  if result.ok then
    return result.value, nil
  else
    if not required then
      vim.notify('Optional module ' .. module .. ' skipped', vim.log.levels.WARN)
    end
    return required and false or nil, result.error
  end
end

-- Load configuration level with try function
function M.load_config_level(level_name, modules, required)
  local success_count = 0
  local level_errors = {}

  vim.notify('Loading ' .. level_name .. ' configuration...', vim.log.levels.INFO)

  for _, module in ipairs(modules) do
    local result, error = M.safe_require(module, { required = required })
    if result then
      success_count = success_count + 1
    elseif error then
      table.insert(level_errors, { module = module, error = error })
    end
  end

  local success_rate = success_count / #modules
  return success_rate > 0.5, success_count, level_errors
end

-- Show error summary if not in safe mode
function M.handle_errors()
  if _G.SAFETY.mode ~= 'normal' then
    vim.notify('Safety configuration loaded with errors (expected)', vim.log.levels.WARN)
    return
  end
  
  if _G.SAFETY.summary_shown then
    return
  end
  
  local all_errors = M.get_all_errors()
  if #all_errors > 0 then
    _G.SAFETY.summary_shown = true
    require('safety.interface').show_error_summary(all_errors)
  else
    local mode_text = _G.SAFETY.mode ~= 'normal' and (' (' .. _G.SAFETY.mode .. ' mode)') or ''
    vim.notify('✓ Configuration loaded successfully!' .. mode_text, vim.log.levels.INFO)
  end
end

-- Handle critical failures
function M.handle_critical_failure()
  if _G.SAFETY.mode == 'normal' then
    local all_errors = M.get_all_errors()
    vim.schedule(function() 
      require('safety.fallback').handle_critical_failure(all_errors) 
    end)
  else
    vim.notify('Safety configuration failed - using emergency settings', vim.log.levels.ERROR)
    require('safety.fallback').apply_emergency_settings()
  end
end

return M