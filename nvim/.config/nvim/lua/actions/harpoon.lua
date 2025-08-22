local M = {}

local harpoon = require 'harpoon'

local function get_buf_name() return vim.api.nvim_buf_get_name(0) end

local function create_mark(filename)
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  return {
    value = filename,
    context = {
      row = cursor_pos[1],
      col = cursor_pos[2],
    },
  }
end

local function validate_buf_name(buf_name)
  if buf_name == '' or buf_name == nil then
    error "Couldn't find a valid file name to mark, sorry."
    return
  end
end

local function filter_filetype()
  local current_filetype = vim.bo.filetype

  if current_filetype == 'harpoon' then
    error "You can't add harpoon to the harpoon"
    return
  end
end

function M.add_file_at_pos(position)
  filter_filetype()
  local buf_name = get_buf_name()
  validate_buf_name(buf_name)

  local list = harpoon:list()

  if not position then
    -- Add to next available slot
    list:add()
    return
  end

  -- Get current items
  local items = list.items or {}

  -- If position is occupied, keep the mark info
  local move, to_move = false, nil
  if items[position] and items[position].value ~= '' then
    to_move = items[position]
    move = true
  end

  -- Create new mark for current file
  local new_mark = create_mark(buf_name)

  -- Extend items table if necessary
  while #items < position do
    table.insert(items, { value = '' })
  end

  -- Assign the desired file to the given position
  items[position] = new_mark

  -- Move the previous mark to an empty slot
  if move then
    local empty_slot = #items + 1
    for i = 1, #items do
      if not items[i] or items[i].value == '' then
        empty_slot = i
        break
      end
    end

    if empty_slot > #items then
      table.insert(items, to_move)
    else
      items[empty_slot] = to_move
    end

    vim.notify(
      string.format(
        '%s assigned to mark %d.\n%s moved to mark %d.',
        new_mark.value,
        position,
        to_move.value,
        empty_slot
      ),
      vim.log.levels.INFO,
      { title = 'Harpoon' }
    )
  end

  -- Use proper Harpoon 2 API to set at position
  list:replace_at(position, new_mark)

  -- If we moved an item, add it back
  if move then
    local empty_slot = #list.items + 1
    for i = 1, #list.items do
      if not list.items[i] or list.items[i].value == '' then
        empty_slot = i
        break
      end
    end
    list:replace_at(empty_slot, to_move)
  end
end

return M
