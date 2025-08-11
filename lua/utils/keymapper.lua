local M = {}

-- Default keymapper
function M.map(spec)
  local which_key, ok = try { require, 'which-key', or_else = require'utils.fallback_keymapper' }
  which_key.add(spec)
end

return M
