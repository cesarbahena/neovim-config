local M = {}

--[[General utils]]

-- Get (or create) global nested table from dot-separated path
function M.global(path)
  local current = _G
  for part in string.gmatch(path, '[^%.]+') do
    current[part] = current[part] or {}
    current = current[part]
  end
  return current
end

-- Helper for command strings with <CR>
function M.cmd(command) return '<cmd>' .. command .. '<cr>' end

-- Helper for vim.cmd.normal with bang
function M.bang(command)
  return function() vim.cmd.normal { command, bang = true } end
end

-- Execute functions sequentially
function M.proc(funcs)
  return function()
    for _, func in ipairs(funcs) do
      func()
    end
  end
end

-- Feed keys with sensible defaults for nvim_replace_termcodes
-- Uses pattern: (str, true, false, true) - standard key feeding
-- Note: If you need do_lt=true for <lt> sequences, use vim.api.nvim_replace_termcodes directly
function M.feed(keys)
  return function()
    local termcodes = vim.api.nvim_replace_termcodes(keys, true, false, true)
    vim.api.nvim_feedkeys(termcodes, 'n', false)
  end
end

-- Returns true only if a *visible* window shows a buffer with given filetype
function M.is_win_open(ft)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buftype = vim.api.nvim_get_option_value('filetype', { buf = buf })
    if buftype == ft then return true end
  end
  return false
end

-- Import fn module
M.fn = require('utils.fn').fn

return M
