vim.g.mapleader = ' '

-- Setup global variables and functions first
require('globals').setup()

-- Simple backup loader using try function
local function load_backup()
  print("Loading backup configuration...")
  
  -- Clear error state
  _G.Errors = {}
  
  -- Set backup mode
  _G.SAFETY = { mode = 'backup' }
  
  -- Modify package path to load from backup
  local backup_path = vim.fn.stdpath('config') .. '/lua/backup/lua'
  local original_path = package.path
  package.path = backup_path .. '/?.lua;' .. backup_path .. '/?/init.lua;' .. package.path
  
  -- Clear modules and load from backup using try function
  local modules = { 'core.options', 'core.keymaps', 'core.lsp' }
  local loaded = 0
  
  for _, module in ipairs(modules) do
    package.loaded[module] = nil
    local result = try(require, module):catch('BackupErrors')
    if result.ok then
      loaded = loaded + 1
    end
  end
  
  -- Restore path
  package.path = original_path
  
  print("Backup loaded:", loaded, "modules")
  return loaded > 0
end

-- Try to load main config first
local main_result = try(function()
  return require('core.package_manager') and 
         require('core.options') and
         require('core.keymaps') and
         require('core.lsp')
end):catch('MainErrors')

if not main_result.ok then
  print("Main config failed, loading backup...")
  if not load_backup() then
    print("Backup also failed, using emergency settings")
    vim.opt.number = true
    vim.keymap.set('n', '<leader>q', ':q<CR>')
  end
else
  print("Main config loaded successfully")
end

-- Show errors if any
vim.schedule(function()
  local all_errors = {}
  for category, errors in pairs(_G.Errors or {}) do
    for _, error in ipairs(errors) do
      table.insert(all_errors, error.module .. ': ' .. error.message)
    end
  end
  
  if #all_errors > 0 then
    vim.notify(table.concat(all_errors, '\n'), vim.log.levels.WARN)
  end
end)