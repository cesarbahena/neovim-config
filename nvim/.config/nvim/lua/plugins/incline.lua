local edgy_filetypes = {
  'neotest-output-panel',
  'neotest-summary',
  'noice',
  'Trouble',
  'OverseerList',
  'Outline',
}

local edgy_titles = {
  ['neotest-output-panel'] = 'neotest',
  ['neotest-summary'] = 'neotest',
  noice = 'noice',
  Trouble = 'trouble',
  OverseerList = 'overseer',
  Outline = 'outline',
}

local function is_edgy_group(props) return vim.tbl_contains(edgy_filetypes, vim.bo[props.buf].filetype) end

-- Shared helper functions
local function to_subscript(n)
  local subscripts = { '₀', '₁', '₂', '₃', '⁴', '₅', '₆', '₇', '₈', '₉' }
  return tostring(n):gsub('%d', function(d) return subscripts[tonumber(d) + 1] end)
end

local function get_git_status_color(props)
  local filepath = vim.api.nvim_buf_get_name(props.buf)
  if filepath == '' then return nil end
  
  -- Get git status for file
  local handle = io.popen('git status --porcelain ' .. vim.fn.shellescape(filepath) .. ' 2>/dev/null')
  if not handle then return nil end
  
  local result = handle:read('*a')
  handle:close()
  
  if result == '' then return nil end  -- Clean file
  
  local status = result:sub(1, 2)
  -- First character: staged, second character: unstaged
  if status:match('^%?%?') then
    return '#a6e3a1'  -- Green for untracked
  elseif status:match('[AM]') then
    return '#fab387'  -- Orange for modified/added
  end
  
  return nil
end

local function get_diagnostic_style(props)
  local errors = vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity.ERROR })
  if #errors > 0 then
    return { color = '#f38ba8', decoration = nil }  -- Red, no decoration
  end
  
  local warnings = vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity.WARN })
  local info = vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity.INFO })
  local hints = vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity.HINT })
  
  if #warnings > 0 or #info > 0 or #hints > 0 then
    return { color = nil, decoration = 'underline' }  -- Underline, no color override
  end
  
  return { color = nil, decoration = nil }  -- No diagnostics
end

local function get_title(props)
  local title = ' ' .. edgy_titles[vim.bo[props.buf].filetype] .. ' '
  local result = {}
  local diag_style = get_diagnostic_style(props)

  -- Build gui style for title: combine diagnostic decoration with focused bold
  local gui_parts = {}
  if props.focused then table.insert(gui_parts, 'bold') end
  if diag_style.decoration then table.insert(gui_parts, diag_style.decoration) end
  local gui_style = #gui_parts > 0 and table.concat(gui_parts, ',') or nil

  -- Add title with diagnostic styling
  table.insert(result, { 
    title, 
    guifg = diag_style.color, 
    gui = gui_style,
    group = props.focused and 'FloatTitle' or 'Title' 
  })

  return result
end

local function get_filename(props)
  local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
  if filename == '' then filename = '[No Name]' end

  -- Get icon and color using mini.icons
  local ft_icon, ft_hl_group = require('mini.icons').get('file', filename)
  local hl_attrs = vim.api.nvim_get_hl(0, { name = ft_hl_group })
  local ft_color = hl_attrs.fg and string.format('#%06x', hl_attrs.fg)

  local result = {}
  local git_color = get_git_status_color(props)
  local diag_style = get_diagnostic_style(props)
  
  -- Build gui style: combine diagnostic decoration, modified italic, and focused bold
  local gui_parts = {}
  if props.focused then table.insert(gui_parts, 'bold') end
  if diag_style.decoration then table.insert(gui_parts, diag_style.decoration) end
  if vim.bo[props.buf].modified then table.insert(gui_parts, 'italic') end
  local gui_style = #gui_parts > 0 and table.concat(gui_parts, ',') or 'none'

  -- Add filename - diagnostic errors override git status colors
  table.insert(result, { ft_icon and (ft_icon .. ' ') or '', guifg = ft_color })
  table.insert(result, { 
    filename, 
    guifg = diag_style.color or git_color or '#ffffff',
    gui = gui_style
  })

  return result
end

return {
  'b0o/incline.nvim',
  dependencies = { 'folke/edgy.nvim' },
  opts = {
    window = {
      zindex = 30,
      margin = {
        vertical = { top = vim.o.laststatus == 3 and 0 or 1, bottom = 0 }, -- shift to overlap window borders
        horizontal = { left = 0, right = 2 },
      },
    },
    ignore = {
      buftypes = {},
      filetypes = {},
      unlisted_buffers = false,
    },
    render = function(props)
      if is_edgy_group(props) then return get_title(props) end

      -- Simple filename for regular files
      return get_filename(props)
    end,
  },
  event = 'VeryLazy',
}
