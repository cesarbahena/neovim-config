local M = {}

M.backup_module = 'backup.init' -- Your backup config at lua/backup/init.lua

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

  vim.notify('Loading your friend\'s backup configuration...', vim.log.levels.INFO)
  
  -- Set safety mode to backup
  _G.SAFETY.mode = 'backup'
  _G.SAFETY.backup_active = true

  -- Modify package.path to prioritize backup modules  
  local backup_path = vim.fn.stdpath 'config' .. '/lua/backup/lua'
  local original_path = package.path
  package.path = backup_path .. '/?.lua;' .. backup_path .. '/?/init.lua;' .. package.path

  -- Clear problematic modules from cache so backup versions load
  for module_name, _ in pairs(package.loaded) do
    if module_name:match '^core%.' or module_name:match '^plugins%.' then
      package.loaded[module_name] = nil
    end
  end

  -- Load backup core modules using try function (honoring your friend's design)
  local core = require('safety.core')
  local backup_modules = { 'core.options', 'core.keymaps', 'core.lsp' }
  local loaded_count = 0
  
  vim.notify('Executing backup modules with try function...', vim.log.levels.INFO)
  
  for _, module in ipairs(backup_modules) do
    local result, error = core.safe_require(module, { required = false, category = 'BackupModules' })
    if result then
      loaded_count = loaded_count + 1
      vim.notify('✓ Loaded backup ' .. module, vim.log.levels.INFO)
    else
      vim.notify('✗ Backup ' .. module .. ' failed: ' .. (error and error.message or 'unknown'), vim.log.levels.WARN)
    end
  end
  
  vim.notify(string.format('✓ Backup loaded %d/%d core modules using try function', loaded_count, #backup_modules), vim.log.levels.INFO)

  -- DON'T restore package path yet - backup modules need to stay accessible
  
  -- Mark backup as successfully loaded
  if loaded_count > 0 then
    vim.notify('✓ Your friend\'s backup system is protecting you', vim.log.levels.INFO)
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
