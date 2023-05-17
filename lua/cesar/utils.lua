
local M = {}

M.imap = function(tbl)
  vim.keymap.set("i", tbl[1], tbl[2], tbl[3])
end

M.nmap = function(tbl)
  vim.keymap.set("n", tbl[1], tbl[2], tbl[3])
end

M.autocmd = function(args)
  local event = args[1]
  local group = args[2]
  local callback = args[3]

  vim.api.nvim_create_autocmd(event, {
    group = group,
    buffer = args[4],
    callback = function()
      callback()
    end,
    once = args.once,
  })
end

function M.tele_cmd(key, fn, opts, buffer)
  local id = vim.api.nvim_replace_termcodes(key..fn, true, true, true)
  vim.g.telescopes = vim.g.telescopes or {}
  vim.g.telescopes[id] = opts or {}

  local rhs = string.format(
    "<cmd>lua require('"..vim.g.user..
    ".plugins.telescope.telescopes')['%s']"..
    "(vim.g.telescopes['%s'])<CR>",
    fn, id
  )

  if not buffer then
    vim.keymap.set('n', key, rhs)
  else
    vim.api.nvim_buf_set_keymap(0, 'n', key, rhs)
  end
end

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
