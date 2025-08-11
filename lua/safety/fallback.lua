local M = {}

-- Check if backup config exists
function M.backup_exists()
  local backup_path = vim.fn.stdpath 'config' .. '/lua/backup/init.lua'
  return vim.fn.filereadable(backup_path) == 1
end

-- Load backup configuration using try function at its core
function M.load_backup_config()
  if not M.backup_exists() then
    vim.notify('Backup config not found at lua/backup/init.lua', vim.log.levels.ERROR)
    M.apply_emergency_settings()
    return
  end

  vim.notify('Loading Vimotee\'s backup configuration...', vim.log.levels.INFO)

  -- Set safety mode to backup first
  _G.SAFETY.mode = 'backup'
  _G.SAFETY.backup_active = true

  -- Clear ALL potentially problematic modules from cache
  local modules_to_clear = {}
  for module_name, _ in pairs(package.loaded) do
    -- Clear all user modules except safety system itself
    if not module_name:match '^safety%.' and 
       not module_name:match '^vim%.' and 
       not module_name:match '^luv$' and
       not module_name == 'globals' then
      table.insert(modules_to_clear, module_name)
    end
  end
  
  -- Clear modules 
  for _, module_name in ipairs(modules_to_clear) do
    package.loaded[module_name] = nil
  end

  -- Clear error state before loading backup
  _G.Errors = {}

  -- Modify package.path to prioritize backup directory structure
  local config_path = vim.fn.stdpath 'config'
  local backup_lua_path = config_path .. '/lua/backup/lua'
  local original_path = package.path

  -- Prepend backup paths so require() finds modules in backup/lua/ first
  package.path = backup_lua_path .. '/?.lua;' .. 
                backup_lua_path .. '/?/init.lua;' .. 
                package.path

  -- Bypass the init guard completely and directly load backup configuration
  local ok, err = pcall(function()
    -- Reset initialization flags to allow backup to run
    _G.SAFETY.initialized = false
    _G.SAFETY.summary_shown = false
    
    -- Clear globals and setup from backup version
    package.loaded['globals'] = nil
    require('globals').setup()
    
    -- Load core backup modules directly using safety core from backup
    local backup_safety_core = require('safety.core')
    
    -- Load core configurations from backup
    local success, count = backup_safety_core.load_config_level('core', {
      'core.options',
      'core.keymaps', 
      'core.lsp',
    }, true)
    
    if not success then
      error('Backup core configuration failed to load')
    end
    
    return true
  end)

  -- Restore original package.path
  package.path = original_path
  
  -- Set backup mode after successful load
  if ok then
    _G.SAFETY.mode = 'backup'
    _G.SAFETY.backup_active = true
  end

  if not ok then
    vim.notify('Vimotee\'s backup config failed to load: ' .. tostring(err), vim.log.levels.ERROR)
    M.apply_emergency_settings()
  else
    vim.notify('✓ Vimotee\'s backup configuration loaded successfully', vim.log.levels.INFO)
    vim.notify('✓ Backup modules active - keymaps and options restored', vim.log.levels.INFO)
  end
end

-- Ultimate emergency fallback
function M.apply_emergency_settings()
  vim.notify('Applying emergency settings...', vim.log.levels.WARN)

  local emergency = {
    function() vim.opt.number = true end,
    function() vim.opt.expandtab = true end,
    function() vim.g.mapleader = ' ' end,
    function() vim.cmd 'colorscheme default' end,
  }

  for _, setting in ipairs(emergency) do
    pcall(setting)
  end

  vim.keymap.set('n', '<leader>q', ':q<CR>')
  vim.keymap.set('n', '<leader>w', ':w<CR>')
end


-- Handle critical failures
function M.handle_critical_failure(errors)
  local prefs = require('safety.prefs').load_prefs()

  if prefs.auto_fallback then
    M.load_backup_config()
  else
    -- Mark that we've already shown the error summary
    _G.SAFETY.summary_shown = true
    require('safety.interface').show_error_summary(errors)
  end
end

return M
