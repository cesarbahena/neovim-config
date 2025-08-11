---@class BackupReloadAPI  
---Prepare system to reload from backup, letting init.lua handle execution
local M = {}

local backup_root = vim.fn.stdpath('config') .. '/lua/backup'
local is_reloading = false

---Check if we're currently in a backup reload to prevent recursion
---@return boolean
function M.is_backup_reload()
  return is_reloading or string.find(package.path, backup_root, 1, true) ~= nil
end

---Prepare system for complete reload from backup
---@return boolean success
function M.prepare_backup_reload()
  if M.is_backup_reload() then
    return false -- Prevent recursion
  end
  
  if vim.fn.isdirectory(backup_root) ~= 1 then
    vim.notify('Backup not found at ' .. backup_root, vim.log.levels.ERROR)
    return false
  end

  is_reloading = true
  
  -- Clear ALL user modules from cache
  for module, _ in pairs(package.loaded) do
    if not module:match('^vim%.') and not module:match('^_') and module ~= 'backup_reload' then
      package.loaded[module] = nil
    end
  end

  -- Set backup as primary source
  package.path = backup_root .. '/?.lua;' .. backup_root .. '/?/init.lua;' .. package.path
  
  return true
end

---Execute backup reload by sourcing backup init.lua
---@return boolean success
function M.reload_from_backup()
  if not M.prepare_backup_reload() then
    return false
  end

  local backup_init = backup_root .. '/init.lua'
  local success = pcall(dofile, backup_init)
  
  -- Reset state
  is_reloading = false
  
  if success then
    _G.Errors = {} -- Clear errors on successful reload
    vim.notify('Config reloaded from backup', vim.log.levels.INFO)
    return true
  else
    vim.notify('Failed to reload from backup', vim.log.levels.ERROR)
    return false
  end
end

---Auto-reload if errors detected
function M.auto_reload_if_errors()
  if _G.Errors and #_G.Errors > 0 and not M.is_backup_reload() then
    vim.notify('Errors detected (' .. #_G.Errors .. '), reloading from backup...', vim.log.levels.WARN)
    return M.reload_from_backup()
  end
  return false
end

---Setup the backup reload system
function M.setup()
  _G.reload_from_backup = M.reload_from_backup
  _G.auto_reload_errors = M.auto_reload_if_errors
  
  -- Schedule auto-reload check
  vim.schedule(M.auto_reload_if_errors)
end

return M