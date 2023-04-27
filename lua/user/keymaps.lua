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

local omap = function(lhs, rhs, desc)
  vim.keymap.set('o', lhs, rhs, { desc = desc })
end

map('s', 'c')
map('n', 'j')
map('\\', 'n')
map('k', 'b')
map('e', 'k')
map('w', 'e')
map('h', 'w')
map('m', 'h')
map('M', 'm')

map('S', 'cc')
map('ss', 'C')
map('N', '<C-d>zz')
map('|', 'N')
map('K', 'B')
map('E', '<C-u>zz')
map('W', 'E')
map('H', 'W')

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

map('D', 'dd')
map('dd', 'D')
map('yy', 'y$')

local tens = {'','k','h',',','n','e','i','l','u','y'}
local units = {'m','k','h',',','n','e','i','l','u','y'}

require('user.numpad').map_numpad{
  prefix = '<leader>',
  tens = tens,
  i = 0,
  n = 2,
  units = units,
  j = 0,
  m = 9,
}

require('user.numpad').map_numpad{
  prefix = '<leader><leader>',
  tens = tens,
  i = 3,
  n = 9,
  units = units,
  j = 0,
  m = 9,
}
-- local units = {'m','k','h',',','n','e','i','l','u','y'}
-- local tens = {'','k','h',',','n','e','i','l','u','y'}
-- for i = 0, 2 do
--   for j = 0, 9 do
--     map(
--       '<leader>' .. tens[i+1] .. units[j+1],
--       string.format('%d%d', i, j)
--     )
--   end
-- end
-- -- For 30 onwards press <leader><leader>
-- for i = 3, 9 do
--   for j = 0, 9 do
--     map(
--       '<leader><leader>' .. tens[i+1] .. units[j+1],
--       string.format('%d%d', i, j)
--     )
--   end
-- end

-- Motions in Insert mode
imap('<M-m>', '<C-o>h')
imap('<M-l>', '<C-o>l')
imap('<M-k>', '<C-o>b')
imap('<M-h>', '<C-o>w')
imap('<M-w>', '<C-o>e')
imap('<M-e>', '<BS>')
imap('<M-u>', '<C-w>')
imap('<M-n>', '<Esc>%%a')
imap('<M-,>', '<C-o>l,<space>')
map('b', '<C-o>')
map('j', '<C-i>')
