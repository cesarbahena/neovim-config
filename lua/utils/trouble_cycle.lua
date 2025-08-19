---@class TroubleCycle
local M = {}

---Get the current trouble item position/identifier
---@return string|nil Current item identifier
local function get_current_item_id()
  if not require('trouble').is_open() then return nil end
  
  -- Try to get current cursor position in trouble window
  local trouble_win = nil
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buf_name = vim.api.nvim_buf_get_name(buf)
    if buf_name:match('Trouble') then
      trouble_win = win
      break
    end
  end
  
  if not trouble_win then return nil end
  
  local cursor = vim.api.nvim_win_get_cursor(trouble_win)
  return string.format("%d:%d", cursor[1], cursor[2])
end

---Cycle to the first item in trouble list
function M.cycle_to_first()
  local fn = require('utils.fn').fn
  fn('trouble.first', { skip_groups = true, jump = true })()
end

---Cycle to the last item in trouble list  
function M.cycle_to_last()
  local fn = require('utils.fn').fn
  fn('trouble.last', { skip_groups = true, jump = true })()
end

---Navigate to next item with cycling
function M.next_with_cycle()
  local fn = require('utils.fn').fn
  
  if not fn('trouble.is_open')() then
    fn('trouble.open', 'diagnostics')()
    return
  end
  
  -- For remote navigation, track current buffer/line
  local current_buf = vim.api.nvim_get_current_buf()
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  
  -- Try normal next
  fn('trouble.next', { skip_groups = true, jump = true })()
  
  -- Check if we're still in the same place after a delay  
  vim.defer_fn(function()
    local new_buf = vim.api.nvim_get_current_buf()
    local new_line = vim.api.nvim_win_get_cursor(0)[1]
    
    if current_buf == new_buf and current_line == new_line then
      -- We didn't move, likely at the end - cycle to first
      M.cycle_to_first()
      vim.notify('Cycled to first')
    end
  end, 100)
end

---Navigate to previous item with cycling  
function M.prev_with_cycle()
  local fn = require('utils.fn').fn
  
  if not fn('trouble.is_open')() then
    fn('trouble.open', 'diagnostics')()
    return
  end
  
  -- For remote navigation, track current buffer/line
  local current_buf = vim.api.nvim_get_current_buf()
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  
  -- Try normal prev
  fn('trouble.prev', { skip_groups = true, jump = true })()
  
  -- Check if we're still in the same place after a delay  
  vim.defer_fn(function()
    local new_buf = vim.api.nvim_get_current_buf()
    local new_line = vim.api.nvim_win_get_cursor(0)[1]
    
    if current_buf == new_buf and current_line == new_line then
      -- We didn't move, likely at the beginning - cycle to last
      M.cycle_to_last()
      vim.notify('Cycled to last')
    end
  end, 100)
end

return M