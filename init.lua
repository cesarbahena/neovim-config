-- Check for backup mode FIRST - before ANYTHING else
if os.getenv('NVIM_BACKUP_MODE') then
  print("=== BACKUP MODE ACTIVATED ===")
  local backup_root = vim.fn.stdpath('config') .. '/lua/backup'
  package.path = backup_root .. '/?.lua;' .. backup_root .. '/?/init.lua;' .. package.path
  print("Backup path set: " .. backup_root)
end

vim.g.mapleader = ' '

-- Setup global variables and functions first
require('globals').setup()
require 'core'

