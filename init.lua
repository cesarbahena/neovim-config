vim.g.mapleader = ' '

-- Setup global variables and functions
require('globals').setup()

-- Run tests for globals
local globals_test = require 'tests.globals'
if not globals_test.print_results() then
  vim.notify('Global tests failed - config may not work properly', vim.log.levels.WARN)
end

local safety = {
  errors = {},
  config_path = vim.fn.stdpath 'config',
  backup_path = vim.fn.stdpath 'config' .. '/backup',
}

-- Get all errors from try function's error storage
local function get_all_errors()
  local all_errors = {}
  for category, errors in pairs(_G.Errors or {}) do
    for _, error in ipairs(errors) do
      table.insert(all_errors, {
        category = category,
        module = error.module,
        error = error.message,
        severity = error.category == 'syntax_error' and 'CRITICAL' or 'ERROR',
        timestamp = error.time,
        line = error.line,
        traceback = error.traceback,
      })
    end
  end
  return all_errors
end

-- Simplified require using try function
local function safe_require(module, required)
  local result = try(require, module):catch(required and 'CriticalErrors' or 'OptionalErrors')
  
  if result.ok then
    return result.value, nil
  else
    if not required then
      vim.notify('Optional module ' .. module .. ' skipped', vim.log.levels.WARN)
    end
    return required and false or nil, result.error
  end
end

-- Progressive configuration loader
local function load_config_level(level_name, modules, required)
  local success_count = 0
  local level_errors = {}

  vim.notify('Loading ' .. level_name .. ' configuration...', vim.log.levels.INFO)

  for _, module in ipairs(modules) do
    local result, error = safe_require(module, required)
    if result then
      success_count = success_count + 1
    elseif error then
      table.insert(level_errors, { module = module, error = error })
    end
  end

  local success_rate = success_count / #modules
  return success_rate > 0.5, success_count, level_errors
end

-- Main configuration loader with fallback levels
local function main_init()
  -- Plugin configuration (important but not critical)
  local plugin_success = load_config_level('plugins', {
    'core.package_manager',
  }, false)

  try(require, 'core.options'):catch 'Options'
  -- Core configuration (critical)
  local core_success, core_count = load_config_level('core', {
    'core.options',
    'core.keymaps',
    'core.lsp',
  }, true)

  if not core_success then return false, 'Critical core configuration failed' end

  return true, 'Configuration loaded successfully'
end

-- Execute main configuration with ultimate fallback protection
local init_ok, init_result = pcall(main_init)

if not init_ok then
  track_error('main_init', init_result, 'CRITICAL')
  vim.schedule(function() require('safety.fallback').handle_critical_failure(safety.errors) end)
else
  -- Schedule success notification and error summary  
  vim.schedule(function()
    local all_errors = get_all_errors()
    if #all_errors > 0 then
      require('safety.interface').show_error_summary(all_errors)
    else
      vim.notify('✓ Configuration loaded successfully!', vim.log.levels.INFO)
    end
  end)
end

-- Global error access for debugging
_G.nvim_safety = safety
