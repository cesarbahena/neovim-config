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

map('S', 'C')
map('N', '<C-d>zz')
map('|', 'N')
map('K', 'B')
map('E', '<C-u>zz')
map('W', 'E')
map('H', 'W')

imap('<C-e>', '<Esc>')
map('<CR>', ':')
nmap('Q', '@@')
nmap('<leader><leader>', function()
  vim.cmd('wa')
  vim.cmd('so')
end)
vmap('p', '"_dP', 'Paste (keeping the register)')
-- nmap('+', '<C-a>')
-- nmap('-', '<C-x>')

-- Line management
nmap('c', 'Yp', 'Copy down')    -- Duplicate line
vmap('c', "yj'>p", 'Copy down') -- Duplicate paragraph
vmap('<M-n>', ":m '>+<CR>gv=gv")
vmap('<M-e>', ":m '<-2<CR>gv=gv")
nmap('<M-n>', ':m +<CR>==')
nmap('<M-e>', ':m -2<CR>==')
imap('<M-n>', '<Esc>:m+<CR>==gi')
imap('<M-e>', '<Esc>:m-2<CR>==gi')
nmap('J', 'mzJ`z')
nmap('gJ', 'mzgJ`z')
map('<leader>e', '<cmd>Explore<CR><CR>')
