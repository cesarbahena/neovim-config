vim.g.mapleader = ' '

-- Check for backup mode via environment variable
if os.getenv 'NVIM_BACKUP_MODE' then
  local backup_root = vim.fn.stdpath 'config' .. '/lua/backup'
  package.path = backup_root .. '/lua/?.lua;' .. backup_root .. '/lua/?/init.lua;' .. package.path
  vim.notify('Backup mode enabled', vim.log.levels.WARN)
end

-- Setup global variables and functions first
require('globals').setup()
require 'core'

