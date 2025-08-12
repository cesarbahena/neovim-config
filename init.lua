-- Add backup path to runtimepath FIRST if SAFE MODE
if vim.env.NVIM_SAFE_MODE == '1' then
  vim.cmd('set runtimepath^=' .. vim.fn.stdpath('config') .. '/backup')
end

require 'core'
