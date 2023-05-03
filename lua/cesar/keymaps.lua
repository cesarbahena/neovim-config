vim.keymap.set('n', '<leader>p', '<cmd>Explore<CR><CR>')

local utils = require(User..'.utils')

utils.remap{
  [''] = {
    { '<cmd>lua Switch_to_keyboard("qwerty")<CR>', { colemak = '<leader><leader>q' }, 'Switch keyboard' },
    { '<cmd>lua Switch_to_keyboard("colemak")<CR>', { qwerty = '<leader><leader>q' }, 'Switch keyboard' },
    { 'c', 's', 'Substitute (same as change)' },
    { 'C', 'ss', 'Substitute to eol (same as change)' },
    { 'j', { colemak = 'n', qwerty = 'j' }, 'Next line' },
    { '<C-d>zz', { colemak = 'N', qwerty = 'J' }, 'Scroll to Next page' },
    { 'k', { colemak = 'e', qwerty = 'k' }, 'prEv line'},
    { '<C-u>zz', { colemak = 'E', qwerty = 'K' }, 'Scroll to prEv line' },
    { 'b', { colemak = 'k', qwerty = 'b'}, 'bacK one word' },
    { 'B', { colemak = 'K', qwerty = 'B'}, 'bacK one WORD' },
    { 'e', 'w', 'Word (rest of it)' },
    { 'E', 'W', 'WORD (rest of it)' },
    { 'w', { colemak = 'h', qwerty = 'n' }, 'Hop to next word' },
    { 'W', { colemak = 'H', qwerty = 'N' }, 'Hop to next WORD' },
    { 'h', { colemak = 'm', qwerty = 'h' }, 'Left (Colemak DH)' },
    { 'm', 'j', 'Mark' },
    { '', '\\', 'Next match' },
    { '', '|', 'Next match' },
    { '<C-o>', { colemak = '<C-u>', qwerty = '<C-i>' }, 'Undo last jump' },
    { '<C-i>', { colemak = '<C-y>', qwerty = '<C-o>' }, 'Redo last jump' },
    {':', '<CR>', 'Cmdline mode'},
  },
  n = {
    { 'dd', 'D', 'Delete line' },
    { 'D', 'dd', 'Delete to eol' },
    { 'yy', 'y$', 'Yank to eol' },
    { 'Yp', 'c', 'Copy down' },
    { ':m +<CR>==', { colemak = '<M-n>', qwerty = '<M-j>' }, 'Move line down' },
    { ':m -2<CR>==', { colemak = '<M-e>', qwerty = '<M-k>' }, 'Move line up' },
    { 'mzJ`z', { colemak = 'J', qwerty = 'M' }, 'Join/Merge lines (pretty)' },
    { 'mzgJ`z', { colemak = 'gJ', qwerty = 'M' }, 'Join/Merge lines (raw)' },
    -- { '<leader><leader>x', utils.execute_file, 'Execute file' },
    { '@@', 'Q', 'Repeat macro' },
  },
  i = {
    { '<Esc>', { colemak = '<C-e>', qwerty = '<C-k>' }, 'Escape to Normal mode' },
    { '<C-o>h', { colemak = '<M-m>', qwerty = '<M-h>' }, 'Left' },
    { '<C-o>l', { colemak = '<M-l>', qwerty = '<M-l>' }, 'Right' },
    { '<C-o>b', { colemak = '<M-k>', qwerty = '<M-b>' }, 'bacK one word' },
    { '<C-o>w', { colemak = '<M-h>', qwerty = '<M-n>' }, 'Hop to next word' },
    { '<C-o>e', '<M-w>', 'Word (end of it)' },
    { '<BS>', { colemak = '<M-e>', qwerty = '<M-k>' }, 'Backspace' },
    { '<C-w>', '<M-u>', 'Undo word' },
    { '<Esc>%%a', { colemak = '<M-n>', qwerty = '<M-j>' }, 'Next (afer parentheses)' },
    { '<C-o>l,<space>', '<M-,>', 'Comma after string' },
  },
  v = {
    { "y'>", 'y', 'Yank (keep the position' },
    { '"_dP', 'p', 'Paste (keeping the register)' },
    { "yj'>p", 'c', 'Copy down' },
    { ":m '>+<CR>gv=gv", { colemak = '<M-n>', qwerty = '<M-j>' }, 'Move line down' },
    { ":m '<-2<CR>gv=gv", { colemak = '<M-e>', qwerty = '<M-k>' }, 'Move line up' },
    { '<gv', '<', 'Deindent (keep selection)' },
    { '>gv', '>', 'Indent (keep selection)' },
  },
}

local digits = {'m','k','h',',','n','e','i','l','u','y'}

utils.map_numpad{
  prefix = '<leader>',
  digits = digits,
  i = 0,
  n = 2,
  j = 0,
  m = 9,
}

utils.map_numpad{
  prefix = '<leader><leader>',
  digits = digits,
  i = 3,
  n = 9,
  j = 0,
  m = 9,
}
