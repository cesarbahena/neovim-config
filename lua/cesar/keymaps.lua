local utils = require(User..'.utils')

local map = function(lhs, rhs, desc)
  vim.keymap.set('', lhs, rhs, { desc = desc })
end

local nmap = function(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { desc = desc })
end

local vmap = function(lhs, rhs, desc)
  vim.keymap.set('v', lhs, rhs, { desc = desc })
end

local imap = function(lhs, rhs, desc)
  vim.keymap.set('i', lhs, rhs, { desc = desc })
end

utils.chain_remap(
  {
    [''] = {
      {'c','s'},
      {'C','ss'},
      {'j','n','\\'},
      {'<C-d>zz','N','|'},
      {'b','k','e','w','h','m','M'},
      {'B','K'},
      {'<C-u>zz','E','W','H'},
    },
  },
  {
    s = 'Substitute (same as change)',
    ss = 'Substitute to eol (same as change)',
    n = 'Next line',
    N = 'Scroll to Next page',
    e = 'prEv line',
    E = 'Scroll to prEv line',
    k = 'bacK one word',
    K = 'bacK one WORD',
    w = 'Word (rest of it)',
    W = 'WORD (rest of it)',
    h = 'Hop to next word',
    H = 'Hop to next WORD',
    m = 'Left (Colemak DH)',
    M = 'Mark',
    ['\\'] = 'Next match',
    ['|'] = 'Next match',
  },
  { '<C-u>zz' }
)

imap('<C-e>', '<Esc>')
map('<CR>', ':')
nmap('Q', '@@')
nmap('<leader><leader>x', function()
  vim.cmd('wa')
  vim.cmd('so')
end)
vmap('p', '"_dP', 'Paste (keeping the register)')

-- Line management
nmap('c', 'Yp', 'Copy down')    -- Duplicate line
vmap('c', "yj'>p", 'Copy down') -- Duplicate paragraph
vmap('<M-n>', ":m '>+<CR>gv=gv")
vmap('<M-e>', ":m '<-2<CR>gv=gv")
nmap('<M-n>', ':m +<CR>==')
nmap('<M-e>', ':m -2<CR>==')
nmap('J', 'mzJ`z')
nmap('gJ', 'mzgJ`z')
map('<leader>p', '<cmd>Explore<CR><CR>')

nmap('D', 'dd')
nmap('dd', 'D')
nmap('yy', 'y$')

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

-- Motions in Insert mode
utils.imap{
  [''] = {
    {'<C-u>zz', '<Nop>'},
    {'<C-u>', '<C-o>', 'Undo last jump'},
    {'<C-y>', '<C-i>', 'Redo last jump'},
  },
  i = {
    {'<M-m>', '<C-o>h', 'Left (Colemak DH)'},
    {'<M-l>', '<C-o>l', 'Right'},
    {'<M-k>', '<C-o>b', 'bacK one word'},
    {'<M-h>', '<C-o>w', 'Hop to next word'},
    {'<M-w>', '<C-o>e', 'Word (end of it)'},
    {'<M-e>', '<BS>', 'Backspace'},
    {'<M-u>', '<C-w>', 'Undo word'},
    {'<M-n>', '<Esc>%%a', 'Next (afer parentheses)'},
    {'<M-,>', '<C-o>l,<space>', 'Comma after string'},
  }
}

