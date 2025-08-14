local hl_groups = {
  StatuslineNormal = { fg = 'white', bold = true },
  StatuslineNormalInactive = { fg = 'white' },
  StatuslineOk = { fg = 'LightGreen', bold = true },
  StatuslineOkInactive = { fg = 'LightGreen' },
  StatuslineError = { fg = '#f38ba8', bold = true },
  StatuslineErrorInactive = { fg = '#f38ba8' },
}

for hl_group, hl in pairs(hl_groups) do
  vim.api.nvim_set_hl(0, hl_group, hl)
end

local sections = {
  lualine_a = {},
  lualine_b = {},
  lualine_c = {},
  lualine_x = {},
  lualine_y = {},
  lualine_z = {},
}

local opts = {
  options = {
    component_separators = '',
    section_separators = '',
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
  dependencies = { 'echasnovski/mini.icons' },
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
