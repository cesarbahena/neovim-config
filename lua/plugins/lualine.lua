local hl_groups = {
  StatuslineNormal = { fg = 'white', bold = true, bg = 'NONE' },
  StatuslineNormalInactive = { fg = 'white', bg = 'NONE' },
  StatuslineOk = { fg = 'LightGreen', bold = true, bg = 'NONE' },
  StatuslineOkInactive = { fg = 'LightGreen', bg = 'NONE' },
  StatuslineWarn = { fg = 'Orange', bold = true, bg = 'NONE' },
  StatuslineWarnInactive = { fg = 'Orange', bg = 'NONE' },
  StatuslineError = { fg = '#f38ba8', bold = true, bg = 'NONE' },
  StatuslineErrorInactive = { fg = '#f38ba8', bg = 'NONE' },
}

for hl_group, hl in pairs(hl_groups) do
  vim.api.nvim_set_hl(0, hl_group, hl)
end

-- Force lualine transparency with multiple methods
local function force_lualine_transparency()
  -- Method 1: Clear all existing lualine highlights
  vim.cmd('highlight clear lualine_a_normal')
  vim.cmd('highlight clear lualine_b_normal') 
  vim.cmd('highlight clear lualine_c_normal')
  
  -- Method 2: Set StatusLine itself to transparent
  vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'NONE' })
  
  -- Method 3: Nuclear option - clear ALL lualine highlights
  local all_highlights = vim.fn.getcompletion('', 'highlight')
  for _, hl in ipairs(all_highlights) do
    if hl:match('^lualine_') then
      vim.api.nvim_set_hl(0, hl, { bg = 'NONE' })
    end
  end
end

vim.api.nvim_create_autocmd({"ColorScheme", "VimEnter"}, {
  callback = function()
    vim.schedule(force_lualine_transparency)
  end,
})

local sections = {
  lualine_a = {},
  lualine_b = {},
  lualine_c = {},
  lualine_x = {},
  lualine_y = {},
  lualine_z = {},
}

-- Create fully transparent theme
local transparent_theme = {
  normal = {
    a = { bg = 'NONE', fg = 'white', gui = 'bold' },
    b = { bg = 'NONE', fg = 'white' },
    c = { bg = 'NONE', fg = 'white' },
    x = { bg = 'NONE', fg = 'white' },
    y = { bg = 'NONE', fg = 'white' },
    z = { bg = 'NONE', fg = 'white' },
  },
  inactive = {
    a = { bg = 'NONE', fg = 'gray' },
    b = { bg = 'NONE', fg = 'gray' },
    c = { bg = 'NONE', fg = 'gray' },
    x = { bg = 'NONE', fg = 'gray' },
    y = { bg = 'NONE', fg = 'gray' },
    z = { bg = 'NONE', fg = 'gray' },
  },
  insert = {
    a = { bg = 'NONE', fg = 'white', gui = 'bold' },
    b = { bg = 'NONE', fg = 'white' },
    c = { bg = 'NONE', fg = 'white' },
  },
  visual = {
    a = { bg = 'NONE', fg = 'white', gui = 'bold' },
    b = { bg = 'NONE', fg = 'white' },
    c = { bg = 'NONE', fg = 'white' },
  },
  replace = {
    a = { bg = 'NONE', fg = 'white', gui = 'bold' },
    b = { bg = 'NONE', fg = 'white' },
    c = { bg = 'NONE', fg = 'white' },
  },
  command = {
    a = { bg = 'NONE', fg = 'white', gui = 'bold' },
    b = { bg = 'NONE', fg = 'white' },
    c = { bg = 'NONE', fg = 'white' },
  },
}

-- Create minimal empty theme to avoid warnings
local empty_theme = {
  normal = { c = { fg = 'white', bg = 'NONE' } },
  inactive = { c = { fg = 'gray', bg = 'NONE' } },
}

local opts = {
  options = {
    theme = empty_theme,
    component_separators = '',
    section_separators = '',
    globalstatus = true,
    disabled_filetypes = {
      winbar = { 'dap-repl' },
    },
  },
  sections = vim.deepcopy(sections),
  inactive_sections = vim.deepcopy(sections),
  winbar = vim.deepcopy(sections),
  inactive_winbar = vim.deepcopy(sections),
}

local function component(type, section, module, name, n)
  if n == nil then
    table.insert(opts[type]['lualine_' .. section], require('ui.' .. module)[name])
    return
  end

  for i = 1, n do
    table.insert(opts[type]['lualine_' .. section], require('ui.' .. module)[name .. '_' .. i])
  end
end

return {
  'nvim-lualine/lualine.nvim',
  lazy = false,
  dependencies = { 'echasnovski/mini.icons', 'xiyaowong/transparent.nvim' },
  opts = function()
    component('sections', 'c', 'file_info', 'cwd')
    component('sections', 'c', 'file_info', 'git')
    component('sections', 'c', 'file_info', 'diff')
    component('sections', 'c', 'file_info', 'diagnostics')
    component('sections', 'x', 'server_info', 'plugins')
    component('sections', 'x', 'server_info', 'lsp', 5)
    component('sections', 'x', 'server_info', 'lsp_error')
    component('winbar', 'c', 'file_info', 'filetype')
    component('winbar', 'c', 'file_info', 'filename')
    component('winbar', 'c', 'file_info', 'unsaved')
    component('inactive_winbar', 'c', 'file_info', 'filetype')
    component('inactive_winbar', 'c', 'file_info', 'inactive_filename')
    component('inactive_winbar', 'c', 'file_info', 'unsaved')
    return opts -- Modified opts
  end,
}
