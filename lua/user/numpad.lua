
local non_zero = function (num)
  if num == 0 then
    return ''
  end
  return num
end

M = {}

function M.map_numpad(params)
  for i = params['i'], params['n'] do
    for j = params['j'], params['m'] do
      vim.keymap.set(
        '',
        params['prefix'] .. params['tens'][i+1] .. params['units'][j+1],
        non_zero(i) .. j
      )
    end
  end
end

return M
