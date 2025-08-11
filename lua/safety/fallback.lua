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

  -- Set global flag to indicate backup mode
  _G.NVIM_BACKUP_MODE = true

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

-- Handle critical failures
function M.handle_critical_failure(errors)
  local prefs = require('safety.prefs').load_prefs()

  if prefs.auto_fallback then
    M.load_backup_config()
  else
    -- Mark that we've already shown the error summary
    _G.NVIM_ERROR_SUMMARY_SHOWN = true
    require('safety.interface').show_error_summary(errors)
  end
end

return M
