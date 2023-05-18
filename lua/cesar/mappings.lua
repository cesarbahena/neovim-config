vim.keymap.set('n', '<space>', '<nop>')
vim.keymap.set('n', '<leader>ft', '<cmd>Explore<CR><CR>')

local utils = require(User .. '.utils')

utils.remap{
  [''] = {
    { '<cmd>lua Switch_to_keyboard("qwerty")<CR>', { colemak = '<leader><leader>q' }, 'Switch keyboard' },
    { '<cmd>lua Switch_to_keyboard("colemak")<CR>', { qwerty = '<leader><leader>q' }, 'Switch keyboard' },
    { 'o', { colemak = 'l' }, 'Open new Line below' },
    { 'O', { colemak = 'L' }, 'Open new Line above' },
    { 'c', 's', 'Substitute (same as change)' },
    { 'C', 'ss', 'Substitute to eol (same as change)' },
    { 'j', { colemak = 'n' }, 'Next line' },
    { '<C-d>zz', { colemak = 'N', qwerty = 'J' }, 'Scroll to Next page' },
    { 'k', { colemak = 'e' }, 'prEv line'},
    { '<C-u>zz', { colemak = 'E', qwerty = 'K' }, 'Scroll to prEv line' },
    { 'b', { colemak = 'k' }, 'bacK one word' },
    { 'B', { colemak = 'K' }, 'bacK one WORD' },
    { 'e', 'w', 'Word (rest of it)' },
    { 'E', 'W', 'WORD (rest of it)' },
    { 'w', { colemak = 'h', qwerty = 'n' }, 'Hop to next word' },
    { 'W', { colemak = 'H', qwerty = 'N' }, 'Hop to next WORD' },
    { 'h', { colemak = 'm' }, 'Left' },
    { 'l', { colemak = 'o' }, 'Right' },
    { 'm', { colemak = 'j' }, 'Mark' },
    { 'n', '\\', 'Next match' },
    { 'N', '|', 'Next match' },
    { '<C-o>', { colemak = '<C-u>', qwerty = '<C-i>' }, 'Undo last jump' },
    { '<C-i>', { colemak = '<C-y>', qwerty = '<C-o>' }, 'Redo last jump' },
    {':', '<CR>', 'Cmdline mode'},
    {'<C-a>', '+', 'Increase count'},
    {'<C-x>', '-', 'Decrease count'},
  },
  n = {
    { 'dd', 'D', 'Delete line' },
    { 'D', 'dd', 'Delete to eol' },
    { 'yy', 'Y', 'Yank line' },
    { 'y$', 'yy', 'Yank to eol' },
    { 'Yp', 'yp', 'Copy down' },
    { 'mzA,<Esc>`z', ',,', 'Insert comma at the end' },
    { 'mzA;<Esc>`z', { colemak = ',h', qwerty = ',m' }, 'Insert semicolon at the end' },
    { ':m +<CR>==', '<C-d>', 'Move line down' },
    { ':m -2<CR>==', '<C-f>', 'Move line up' },
    { 'mzJ`z', { colemak = 'J', qwerty = 'M' }, 'Join/Merge lines (pretty)' },
    { 'mzgJ`z', { colemak = 'gJ', qwerty = 'gM' }, 'Join/Merge lines (raw)' },
    { '@@', 'Q', 'Repeat macro' },
  },
  i = {
    { '<Esc>', { colemak = '<C-e>', qwerty = '<C-k>' }, 'Escape to normal mode' },
    { '<C-o>', { colemak = '<C-l>' }, 'Do one normal mode command' },
    { '<BS>', '<C-u>', 'Backspace' },
    { '<Del>', '<C-x>', 'Delete' },
    { '<Esc>va{A', { colemak = '<C-k>', qwerty = '<C-b>' }, 'Go outside of the brackets' },
    { '<Esc>va(A', { colemak = '<C-h>', qwerty = '<C-j>' }, 'Go outside of parentheses)' },
    { '<Esc>la,<space>', '<C-w>', 'Comma after string' },
    { "<Esc>:m+<CR>==gi", '<C-d>', 'Move line down' },
    { "<Esc>:m-2<CR>==gi", '<C-f>', 'Move line up' },
  },
  v = {
    { '<Esc>', { colemak = '<C-e>', qwerty = '<C-k>' }, 'Escape to normal mode' },
    { "y`>", 'y', 'Yank (keep the position' },
    { '"_dP', 'p', 'Paste (keeping the register)' },
    { ":m '>+<CR>gv=gv", '<C-d>', 'Move line down' },
    { ":m '<-2<CR>gv=gv", '<C-f>', 'Move line up' },
    { '<gv', '<', 'Deindent (keep selection)' },
    { '>gv', '>', 'Indent (keep selection)' },
  },
}

-- local digits = {'m','k','h',',','n','e','i','l','u','y'}
--
-- utils.map_numpad{
--   prefix = '<leader>',
--   digits = digits,
--   i = 0,
--   n = 2,
--   j = 0,
--   m = 9,
-- }
--
-- utils.map_numpad{
--   prefix = '<leader><leader>',
--   digits = digits,
--   i = 3,
--   n = 9,
--   j = 0,
--   m = 9,
-- }
