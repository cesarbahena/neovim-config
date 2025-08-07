local M = {}

-- Insert mode with blank line indentation
function M.insert_mode_indent_blankline()
  if #vim.fn.getline '.' == 0 then
    return [["_cc]]
  else
    return 'i'
  end
end

-- Delete line without yanking blank lines
function M.delete_line_no_yank_blankline()
  if vim.api.nvim_get_current_line():match '^%s*$' then return '"_dd' end
  return 'dd'
end

-- Change visual mode
function M.change_visual_mode()
  if vim.fn.mode():find 'V' then return 'v' end
  return 'V'
end

function M.toggle_macro_recording()
  if not vim.g.recording then
    vim.g.recording = true
    vim.cmd 'normal! qq'
    print 'Recording...'
  else
    vim.g.recording = false
    vim.cmd 'normal! q'
    print 'Stopped recording'
  end
end

function M.flash_aware_treesitter()
  local flash = require 'flash'
  local flash_char = require 'flash.plugins.char'

  if flash_char.visible() then
    -- Manually trigger what happens when 't' is pressed while flash is active
    flash_char.jumping = true
    local autohide = require('flash.config').get('char').autohide
    flash_char.jump 't'
    vim.schedule(function()
      flash_char.jumping = false
      if flash_char.state and autohide then flash_char.state:hide() end
    end)
  else
    flash.treesitter()
  end
end

return M
