return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '' },
      topdelete = { text = '' },
      changedelete = { text = '▎' },
      untracked = { text = '▎' },
    },
    signs_staged = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '' },
      topdelete = { text = '' },
      changedelete = { text = '▎' },
    },
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc }) end
      keymap {
        normal {
          'Next Hunk',
          fn {
            cond = 'vim.wo.diff',
            function ()
              vim.cmd.normal { ']c', bang = true }
            end, 
            fallback = function ()
              gs.nav_hunk 'next'
            end
          }
        },

        normal {
          'Prev hunK',
          function()
            if vim.wo.diff then
              vim.cmd.normal { '[c', bang = true }
            else
              gs.nav_hunk 'prev'
            end
          end,
        },
      }
    end,
  },
}
