-- Initialize safety system
_G.SAFETY = _G.SAFETY or {
  mode = 'normal',        -- 'normal', 'backup', 'emergency'
  initialized = false,
  summary_shown = false,
}

-- Prevent multiple executions
if _G.SAFETY.initialized then
  print("DEBUG: init.lua already executed, skipping")
  return
end
_G.SAFETY.initialized = true

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

-- Load safety core system (built around your friend's try function)
local safety_core = require('safety.core')

-- Main configuration loader using your friend's try function
local function main_init()
  -- Plugin configuration (important but not critical)
  local plugin_success = safety_core.load_config_level('plugins', {
    'core.package_manager',
  }, false)

  -- Core configuration (critical) - using try function
  local core_success, core_count = safety_core.load_config_level('core', {
    'core.options',
    'core.keymaps', 
    'core.lsp',
  }, true)

  if not core_success then return false, 'Critical core configuration failed' end

  return true, 'Configuration loaded successfully'
end

-- Execute main configuration with ultimate fallback protection  
local init_ok, init_result = pcall(main_init)

print("DEBUG: init_ok =", init_ok, "init_result =", init_result)

if not init_ok then
  print("DEBUG: Critical failure - activating your friend's safety system")
  safety_core.handle_critical_failure()
else
  print("DEBUG: Configuration loaded - checking with try function")
  vim.schedule(function()
    safety_core.handle_errors()
  end)
end

-- Global error access for debugging
_G.nvim_safety = safety
