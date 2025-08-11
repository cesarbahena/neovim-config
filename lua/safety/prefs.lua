local M = {}

M.prefs_file = vim.fn.stdpath 'data' .. '/config_safety_prefs.json'

function M.load_prefs()
  local file = io.open(M.prefs_file, 'r')
  if not file then
    return {
      auto_fallback = false,
      show_error_details = true,
      remember_choice = false,
      backup_preference = 'ask',
    }
  end

  local content = file:read '*all'
  file:close()

  local ok, prefs = pcall(vim.json.decode, content)
  return ok and prefs
    or {
      auto_fallback = false,
      show_error_details = true,
      remember_choice = false,
      backup_preference = 'ask',
    }
end

function M.save_prefs(prefs)
  local file = io.open(M.prefs_file, 'w')
  if file then
    file:write(vim.json.encode(prefs))
    file:close()
    return true
  end
  return false
end

return M
