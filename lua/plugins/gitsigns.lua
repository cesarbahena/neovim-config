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
      keymap {
        buffer = buffer,

        -- Navigation
        key { 'next Hunk', fn { bang ']c', when = 'vim.wo.diff', or_else = { 'gitsigns.nav_hunk', 'next' } } },
        key { 'prev Hunk', fn { bang '[c', when = 'vim.wo.diff', or_else = { 'gitsigns.nav_hunk', 'prev' } } },
        key { 'last Hunk', fn('gitsigns.nav_hunk', 'last') },
        key { 'first Hunk', fn('gitsigns.nav_hunk', 'first') },

        -- Stage/Reset operations
        edit { 'Stage hunk', cmd 'Gitsigns stage_hunk' },
        edit { 'Reset hunk', cmd 'Gitsigns reset_hunk' },
        key { 'Stage buffer', fn 'gitsigns.stage_buffer' },
        key { 'Reset buffer', fn 'gitsigns.reset_buffer' },
        key { 'Undo stage hunk', fn 'gitsigns.undo_stage_hunk' },

        -- Preview and blame
        key { 'Preview hunk inline', fn 'gitsigns.preview_hunk_inline' },
        key { 'Blame line', fn('gitsigns.blame_line', { full = true }) },
        key { 'Blame buffer', fn 'gitsigns.blame' },

        -- Diff operations
        key { 'diff This', fn 'gitsigns.diffthis' },
        key { 'diff This ~', fn('gitsigns.diffthis', '~') },

        -- Text object
        operator { 'Inner Hunk', cmd 'Gitsigns select_hunk' },
      }
    end,
  },
}
