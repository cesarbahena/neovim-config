return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'echasnovski/mini.nvim' },
  event = 'VeryLazy',
  config = function()
    local icons = require 'mini.icons' -- mini.icons module

    require('lualine').setup {
      options = {
        theme = 'auto',
        section_separators = { '', '' },
        component_separators = { '', '' },
        globalstatus = true,
      },
      sections = {
        -- Left: Git info
        lualine_a = {},
        lualine_b = {
          { 'branch', icon = icons.git.Branch or '' },
          {
            'diff',
            symbols = {
              added = icons.git.Add or '●',
              modified = icons.git.Mod or '✚',
              removed = icons.git.Remove or '✖',
            },
          },
        },
        lualine_c = {},
        -- Right: Languages + Docker
        lualine_x = {
          { 'python', fmt = function(v) return (icons.lang.Python or '🐍') .. ' ' .. v end },
          { 'node', fmt = function(v) return (icons.lang.Node or '⬢') .. ' ' .. v end },
          { 'docker', fmt = function() return icons.lang.Docker or '🐳' end },
        },
        lualine_y = {},
        lualine_z = {},
      },
    }
  end,
}
