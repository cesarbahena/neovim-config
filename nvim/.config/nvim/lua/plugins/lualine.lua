-- Minimal theme to fix component spacing
local minimal_theme = {
  normal = {
    c = { bg = 'NONE' },
    x = { bg = 'NONE' },
  },
  inactive = {
    c = { bg = 'NONE' },
    x = { bg = 'NONE' },
  },
}

-- Add custom colors to theme
minimal_theme.normal.StatuslineError = { fg = '#f38ba8', gui = 'bold' }
minimal_theme.inactive.StatuslineError = { fg = '#f38ba8' }

return {
  'nvim-lualine/lualine.nvim',
  lazy = false,
  dependencies = { 'echasnovski/mini.icons' },
  opts = {
    options = {
      theme = minimal_theme,
      component_separators = '',
      section_separators = '',
      globalstatus = true,
      disabled_filetypes = {
        winbar = { 'dap-repl' },
      },
    },
    tabline = {
      lualine_a = {
        {
          '%{fnamemodify(getcwd(), ":~")}',
          color = { fg = '#7FB4CA' },
          padding = { left = 0 },
        },
      },
      lualine_z = {},
    },
    sections = {},
  },
}
