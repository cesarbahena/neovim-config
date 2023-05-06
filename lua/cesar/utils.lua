
local M = {}

function M.non_zero(num)
  if num == 0 then
    return ''
  end
  return num
end

function M.remap(table_of_remaps)
  for mode, remaps in pairs(table_of_remaps) do
    for _, remap in ipairs(remaps) do
      local lhs = remap[2]
      if type(lhs) == 'table' then
        lhs = lhs[vim.g.keyboard]
      end
      if lhs then
        vim.keymap.set(
          mode,
          lhs,
          remap[1],
          { desc = remap[3]}
        )
      else
        vim.keymap.set(
          mode,
          remap[1],
          remap[1],
          { desc = remap[3]}
        )
      end
    end
  end
end

function M.map_numpad(params)
  local tens = vim.deepcopy(params['digits'])
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

function M.execute_file()
  vim.cmd('wa')
  vim.cmd('so')
end

return M
