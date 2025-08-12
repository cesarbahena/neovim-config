print("MAIN: Starting init.lua")

-- Add backup path to runtimepath FIRST if BACKUP_PATH is set
if vim.env.NVIM_BACKUP_PATH then
  vim.opt.rtp:prepend(vim.env.NVIM_BACKUP_PATH)
end

require 'core'
