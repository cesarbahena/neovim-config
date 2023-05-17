return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons'
    },
    config = function()

      local conditions = {
        buffer_not_empty = function()
          return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
        end,
        check_git_workspace = function()
          local filepath = vim.fn.expand('%:p:h')
          local gitdir = vim.fn.finddir('.git', filepath .. ';')
          return gitdir and #gitdir > 0 and #gitdir < #filepath
        end,
      }

      require('lualine').setup {
        options = {
          component_separators = '',
          section_separators = '',
        },
        sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            {
              "%{fnamemodify(getcwd(), ':t')}",
              icon = ' ',
            },
            {
              'branch',
              icon = '',
              color = function ()
                vim.fn.systemlist("git diff --quiet " .. vim.fn.expand('%'))
                if vim.v.shell_error == 1 then
                  return { fg = 'orange' }
                end
              end
            },
            {
              'filetype',
              icon_only = true,
              colored = false,
              color = function ()
                local dx = vim.diagnostic
                if #dx.get(0, { severity = dx.severity.ERROR }) > 0 then
                  return { fg = 'orange' }
                elseif #dx.get(0, { severity = dx.severity.WARN }) > 0 then
                  return { fg = 'yellow' }
                end
              end,
              padding = { left = 1, right = 0 },
            },
            {
              function ()
                return vim.fn.fnamemodify(vim.fn.expand '%:p', ':t:r')
              end,
              color = function ()
                local dx = vim.diagnostic
                if #dx.get(0, { severity = dx.severity.ERROR }) > 0 then
                  return { fg = 'orange' }
                elseif #dx.get(0, { severity = dx.severity.WARN }) > 0 then
                  return { fg = 'yellow' }
                end
              end,
            },
            {
              function ()
                if vim.o.modified then
                  return ''
                end
                return ''
              end,
              padding = { left = 0 },
            }
          },
          lualine_x = {
            {
              function()
                return vim.g.keyboard
              end,
              icon = ' ',
            },
            {
              function()
                local msg = 'No LSP'
                local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                local clients = vim.lsp.get_active_clients()
                if next(clients) == nil then
                  return msg
                end
                for _, client in ipairs(clients) do
                  local filetypes = client.config.filetypes
                  if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                    return client.name
                  end
                end
                return msg
              end,
              icon = ' ',
            },
          },
          lualine_y = {},
          lualine_z = {},
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          lualine_c = {},
          lualine_x = {},
        },
      }
    end,
  },
}
