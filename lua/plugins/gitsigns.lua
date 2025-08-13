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
          'next Hunk',
          fn {
            { vim.cmd.normal, { ']c', bang = true } },
            when = 'vim.wo.diff',
            or_else = { 'gitsigns.nav_hunk', 'next' },
          },
        },

        normal {
          'next Hunk',
          fn {
            { vim.cmd.normal, { '[c', bang = true } },
            when = 'vim.wo.diff',
            or_else = { 'gitsigns.nav_hunk', 'prev' },
          },
        },
      }
    end,
  },
}
