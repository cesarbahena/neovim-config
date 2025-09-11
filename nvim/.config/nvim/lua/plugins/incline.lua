-- New adapted configuration for edgy support

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
local function get_git_diff(props)
  local icons = { removed = ' ', changed = ' ', added = ' ' }
  local signs = vim.b[props.buf].gitsigns_status_dict
  local labels = {}
  if signs == nil then return labels end
  for name, icon in pairs(icons) do
    if tonumber(signs[name]) and signs[name] > 0 then
      table.insert(labels, { icon .. signs[name] .. ' ', group = 'Diff' .. name })
    end
  end
  return labels
end

local function get_diagnostic_label(props)
  local icons = { error = ' ', warn = ' ', info = ' ', hint = ' ' }
  local label = {}

  for severity, icon in pairs(icons) do
    local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
    if n > 0 then table.insert(label, { icon .. n .. ' ', group = 'DiagnosticSign' .. severity }) end
  end
  return label
end

local function get_title(props)
  local title = ' ' .. edgy_titles[vim.bo[props.buf].filetype] .. ' '

  local result = {}
  local diagnostics = get_diagnostic_label(props)
  local git = get_git_diff(props)

  -- Add diagnostics on the left
  for _, item in ipairs(diagnostics) do
    table.insert(result, item)
  end

  -- Add git info in the center
  for _, item in ipairs(git) do
    table.insert(result, item)
  end

  -- Add title on the right
  if #diagnostics > 0 then table.insert(result, { ' ' }) end
  table.insert(result, { title, group = props.focused and 'FloatTitle' or 'Title' })
  if #git > 0 then table.insert(result, { ' ' }) end

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
  local diagnostics = get_diagnostic_label(props)
  local git = get_git_diff(props)

  -- Add diagnostics on the left
  for _, item in ipairs(diagnostics) do
    table.insert(result, item)
  end

  -- Add git info in the center
  for _, item in ipairs(git) do
    table.insert(result, item)
  end

  -- Add filename on the right
  if #diagnostics > 0 then table.insert(result, { ' ' }) end
  table.insert(result, { ft_icon and (ft_icon .. ' ') or '', guifg = ft_color })
  table.insert(result, { filename, gui = vim.bo[props.buf].modified and 'bold,italic' or 'bold' })
  table.insert(result, { vim.bo[props.buf].modified and ' ●' or '', guifg = '#d19a66' })
  if #git > 0 then table.insert(result, { ' ' }) end

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
