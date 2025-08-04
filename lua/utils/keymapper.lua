local M = {}

-- Default keymapper
function M.map(spec)
  try(require, 'which-key')
    :catch'MissingKeymappingLibrary'(
      require'utils.fallback_keymapper'
    ).add(spec)
end

return M
