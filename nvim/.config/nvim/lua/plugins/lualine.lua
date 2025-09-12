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

-- Harpoon highlight groups - reliable foreground styling
vim.api.nvim_set_hl(0, 'StatuslineHarpoonActive', { fg = '#61afef', bold = true })
vim.api.nvim_set_hl(0, 'StatuslineHarpoonInactive', { fg = '#666666' })

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
        {
          'branch',
          icon = 'on',
          color = { fg = '#938AA9' },
          padding = { left = 1, right = 0 },
        },
        {
          fn 'components.file_info.git_status',
          color = { fg = '#E6C384', gui = 'bold' },
        },
        {
          function()
            local harpoon = require 'harpoon'
            local marks = harpoon:list().items
            local current_file_path = vim.fn.expand '%:p:.'
            local result = {}

            for _, item in ipairs(marks) do
              local filename = vim.fn.fnamemodify(item.value, ':t'):gsub('%..*', '')

              if item.value == current_file_path then
                table.insert(result, '-t ' .. filename) -- Active: -t filename
              else
                table.insert(result, ' --' .. filename) -- Inactive: --filename
              end
            end

            return table.concat(result, ' ')
          end,
          color = { fg = '#666666' },
        },
      },
      lualine_z = {
        'lsp_status',
      },
    },
    sections = {
      lualine_c = {
        '%=',
        {
          'diagnostics',
          sources = { 'nvim_workspace_diagnostic' },
          symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
        },
      },
      lualine_a = {},
      lualine_b = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
  },
}
