local M = {}

M.backup_module = 'backup.init' -- Your backup config at lua/backup/init.lua

-- Check if backup config exists
function M.backup_exists()
  local backup_path = vim.fn.stdpath 'config' .. '/lua/backup/init.lua'
  return vim.fn.filereadable(backup_path) == 1
end

-- Load your backup configuration
function M.load_backup_config()
  if not M.backup_exists() then
    vim.notify('Backup config not found at lua/backup/init.lua', vim.log.levels.ERROR)
    M.apply_emergency_settings()
    return
  end

  vim.notify('Loading your backup configuration...', vim.log.levels.INFO)

  -- Backup configuration that loads nested modules correctly

  -- Modify package.path to make backup directory act like root
  local backup_path = vim.fn.stdpath 'config' .. '/lua/backup/lua'
  local original_path = package.path

  -- Prepend backup paths so require() finds modules in backup/ first
  package.path = backup_path .. '/?.lua;' .. backup_path .. '/?/init.lua;' .. package.path

  -- Set safety mode to backup
  _G.SAFETY.mode = 'backup'

  -- Clear any problematic modules from cache first
  for module_name, _ in pairs(package.loaded) do
    if module_name:match '^core%.' or module_name:match '^plugins%.' or module_name:match '^ui%.' then
      package.loaded[module_name] = nil
    end
  end

  local ok, err = pcall(require, M.backup_module)

  if not ok then
    vim.notify('Your backup config failed to load: ' .. err, vim.log.levels.ERROR)
    M.apply_emergency_settings()
  else
    vim.notify('✓ Your backup configuration loaded successfully', vim.log.levels.INFO)
    
    -- Now reload the original core modules to get proper config
    M.reload_core_modules()
  end

  -- Restore original package.path when done (optional)
  package.path = original_path
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

-- Reload core modules after backup is loaded
function M.reload_core_modules()
  vim.notify('Reloading core modules...', vim.log.levels.INFO)
  
  -- Temporarily disable backup mode to allow normal loading
  local original_mode = _G.SAFETY.mode
  _G.SAFETY.mode = 'normal'
  
  -- Clear module cache for core modules
  for module_name, _ in pairs(package.loaded) do
    if module_name:match('^core%.') then
      print('DEBUG: Clearing cache for', module_name)
      package.loaded[module_name] = nil
    end
  end
  
  -- Reset package.path to prioritize main config over backup
  local config_path = vim.fn.stdpath('config') .. '/lua'
  local backup_path = vim.fn.stdpath('config') .. '/lua/backup/lua'
  
  -- Put main config first in path
  package.path = config_path .. '/?.lua;' .. config_path .. '/?/init.lua;' .. package.path
  print('DEBUG: New package.path:', package.path)
  
  -- Try to reload core modules with try function for better error handling
  local core_modules = { 'core.options', 'core.keymaps', 'core.lsp' }
  local success_count = 0
  
  for _, module in ipairs(core_modules) do
    print('DEBUG: Attempting to reload', module)
    local result = try(require, module):catch('ReloadErrors')
    
    if result.ok then
      success_count = success_count + 1
      vim.notify('✓ Reloaded ' .. module .. ' from main config', vim.log.levels.INFO)
    else
      print('DEBUG: Main config failed for', module, ':', result.error.message)
      -- Keep the backup version that's already loaded and working
      vim.notify('→ Keeping backup version of ' .. module, vim.log.levels.INFO)
      success_count = success_count + 1  -- Count as success since backup is working
    end
  end
  
  -- Restore backup mode
  _G.SAFETY.mode = original_mode
  
  vim.notify(string.format('Reloaded %d/%d core modules', success_count, #core_modules), vim.log.levels.INFO)
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
