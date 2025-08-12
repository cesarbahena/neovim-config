-- Add backup path to runtimepath FIRST if BACKUP_PATH is set
if vim.env.NVIM_BACKUP_PATH then
  vim.cmd('set runtimepath^=' .. vim.env.NVIM_BACKUP_PATH)
end

require 'core'
