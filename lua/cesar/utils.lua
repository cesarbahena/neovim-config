
local M = {}

function M.found(value, table)
  local found = false
  for _, v in ipairs(table) do
    if v == value then
      found = true
      break
    end
    return found
  end
end

function M.non_zero(num)
  if num == 0 then
    return ''
  end
  return num
end

function M.imap(table_of_remaps)
  for mode, remaps in pairs(table_of_remaps) do
    for i, remap in ipairs(remaps) do
      vim.keymap.set(
        mode,
        remaps[i][1],
        remaps[i][2],
        { desc = remaps[i][3]}
      )
    end
  end
end

function M.chain_remap(table_of_remaps, table_of_desc, ignore)
  for mode, table_of_keys in pairs(table_of_remaps) do
    for _, keys in ipairs(table_of_keys) do
      for i, rhs in ipairs(keys) do
        local lhs = keys[i+1]
        if lhs and not M.found(lhs, ignore) then
          vim.keymap.set(mode, lhs, rhs, { desc = table_of_desc[lhs] })
        end
      end
    end
  end
end

function M.map_numpad(params)
  local tens = Copy(params['digits'])
  tens[1] = ''
  for i = params['i'], params['n'] do
    for j = params['j'], params['m'] do
      vim.keymap.set(
        '',
        params['prefix'] .. tens[i+1] .. params['digits'][j+1],
        M.non_zero(i) .. j
      )
    end
  end
end

return M
