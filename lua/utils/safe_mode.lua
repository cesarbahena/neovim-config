---@class SafeModeAPI
---Save errors on exit, check on startup, offer safe mode from backup
local M = {}

local backup_root = vim.fn.stdpath('config') .. '/lua/backup'
local error_file = vim.fn.stdpath('data') .. '/errors.json'

---Save current errors to file on exit
local function save_errors_on_exit()
  if _G.Errors and #_G.Errors > 0 then
    local file = io.open(error_file, 'w')
    if file then
      file:write(vim.json.encode(_G.Errors))
      file:close()
    end
  end
end

---Load previous errors from file
---@return table|nil errors
local function load_previous_errors()
  local file = io.open(error_file, 'r')
  if file then
    local content = file:read('*all')
    file:close()
    local ok, errors = pcall(vim.json.decode, content)
    return ok and errors or nil
  end
  return nil
end

---Clear saved errors file
local function clear_saved_errors()
  os.remove(error_file)
end

---Enable safe mode by prepending backup to path
local function enable_safe_mode()
  if vim.fn.isdirectory(backup_root) == 1 then
    package.path = backup_root .. '/?.lua;' .. backup_root .. '/?/init.lua;' .. package.path
    vim.notify('Safe mode enabled - loading from backup', vim.log.levels.WARN)
    clear_saved_errors()
    return true
  else
    vim.notify('Backup directory not found at ' .. backup_root, vim.log.levels.ERROR)
    return false
  end
end

---Check for previous errors and offer safe mode
function M.check_startup_errors()
  local previous_errors = load_previous_errors()
  
  if previous_errors and type(previous_errors) == 'table' and #previous_errors > 0 then
    local error_count = #previous_errors
    local choice = vim.fn.confirm(
      'Previous session had ' .. error_count .. ' error(s). Start in safe mode?',
      '&Yes (Safe mode)\n&No (Normal startup)\n&Show errors',
      1
    )
    
    if choice == 1 then
      return enable_safe_mode()
    elseif choice == 3 then
      vim.notify('Previous errors:', vim.log.levels.INFO)
      for i, err in ipairs(previous_errors) do
        print(string.format('[%d] %s: %s', i, err.category or 'unknown', err.message or 'no message'))
      end
      local retry = vim.fn.confirm('Start in safe mode?', '&Yes\n&No', 1)
      if retry == 1 then
        return enable_safe_mode()
      end
    end
    
    -- Clear errors if user chose normal startup
    clear_saved_errors()
  end
  
  return false
end

---Setup the backup reload system
function M.setup()
  -- Check for previous errors on startup
  M.check_startup_errors()
  
  -- Save errors on exit
  vim.api.nvim_create_autocmd('VimLeavePre', {
    callback = save_errors_on_exit,
    desc = 'Save errors before exit'
  })
  
  -- Make functions globally available
  _G.safe_mode = enable_safe_mode
  _G.check_errors = M.check_startup_errors
end

return M