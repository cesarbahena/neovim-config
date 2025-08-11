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

-- Track all errors with context
local function track_error(module, error_msg, severity)
  table.insert(safety.errors, {
    module = module,
    error = error_msg,
    severity = severity or 'ERROR',
    timestamp = os.date '%Y-%m-%d %H:%M:%S',
    stack = debug.traceback(),
  })

  vim.notify(
    string.format("Module '%s' failed: %s", module, error_msg),
    severity == 'WARN' and vim.log.levels.WARN or vim.log.levels.ERROR,
    { title = 'Config Safety' }
  )
end

-- Safe module loader with syntax/runtime error detection
local function safe_require(module, required)
  required = required or false

  -- First attempt - catches both syntax and runtime errors
  local ok, result = pcall(require, module)
  if not ok then
    -- Determine error type
    local error_type = 'RUNTIME_ERROR'
    if string.match(result, 'module.*not found') then
      error_type = 'MODULE_NOT_FOUND'
    elseif string.match(result, 'syntax error') or string.match(result, 'expected') then
      error_type = 'SYNTAX_ERROR'
    end

    track_error(module, result, required and 'ERROR' or 'WARN')

    if required then
      return false, result
    else
      vim.notify('Optional module ' .. module .. ' skipped', vim.log.levels.WARN)
      return nil, result
    end
  end

  return result, nil
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
    if #safety.errors > 0 then
      require('safety.interface').show_error_summary(safety.errors)
    else
      vim.notify('✓ Configuration loaded successfully!', vim.log.levels.INFO)
    end
  end)
end

-- Global error access for debugging
_G.nvim_safety = safety
