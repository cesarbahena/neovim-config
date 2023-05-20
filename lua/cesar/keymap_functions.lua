Keymaps = {}

function Keymaps.remap(table_of_remaps)
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
          remap[3],
          { desc = remap[1] }
        )
      else
        vim.keymap.set(
          mode,
          remap[3],
          remap[3],
          { desc = remap[1] }
        )
      end
    end
  end
end

function Keymaps.map_telescope(key, fn, opts, buffer)
  local id = vim.api.nvim_replace_termcodes(key .. fn, true, true, true)
  Telescopes = Telescopes or {}
  Telescopes[id] = opts or {}

  local rhs = string.format(
    "<cmd>lua Plugin 'telescope.telescopes'['%s'](Telescopes['%s'])<CR>",
    fn, id
  )

  if not buffer then
    vim.keymap.set('n', key, rhs)
  else
    vim.api.nvim_buf_set_keymap(0, 'n', key, rhs)
  end
  -- vim.notify(fn)
end

local function non_zero(num)
  if num == 0 then
    return ''
  end
  return num
end

function Keymaps.map_numpad(params)
  local tens = vim.deepcopy(params['digits'])
  tens[1] = ''
  for i = params['i'], params['n'] do
    for j = params['j'], params['m'] do
      vim.keymap.set(
        '',
        params['prefix'] .. tens[i + 1] .. params['digits'][j + 1],
        non_zero(i) .. j
      )
    end
  end
end

return Keymaps
