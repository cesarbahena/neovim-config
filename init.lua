vim.g.mapleader = ' '

-- Check for safe mode and set path BEFORE any config loading
local error_file = vim.fn.stdpath('data') .. '/errors.json'
local backup_root = vim.fn.stdpath('config') .. '/lua/backup'

local file = io.open(error_file, 'r')
if file then
  local content = file:read('*all')
  file:close()
  local ok, errors = pcall(vim.json.decode, content)
  if ok and errors and #errors > 0 then
    local choice = vim.fn.confirm('Previous session had ' .. #errors .. ' error(s). Start in safe mode?', '&Yes\n&No', 1)
    if choice == 1 then
      package.path = backup_root .. '/?.lua;' .. backup_root .. '/?/init.lua;' .. package.path
      vim.notify('Safe mode enabled - loading from backup', vim.log.levels.WARN)
      os.remove(error_file)
    end
  end
end

-- Setup global variables and functions first
require('globals').setup()

-- Setup safe mode system (for exit handler)
require('utils.safe_mode').setup()

try {
  require,
  { 'core.package_manager' },
  { 'core.options' },
  { 'core.keymaps' },
  { 'core.lsp' },
}
