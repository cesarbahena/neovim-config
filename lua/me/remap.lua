local map = vim.keymap.set
vim.g.mapleader = ' '

function Vcheck(mode, motion)
  -- Check if we're already in visual line mode
  if vim.fn.mode() == mode then
    -- If so, move the cursor down
    vim.cmd('normal! ' .. motion)
  elseif vim.fn.mode() == string.upper(mode) then
    -- Otherwise, enter visual line mode and move down
    vim.cmd('normal! ' .. mode .. motion)
  else
    vim.cmd('normal!' .. motion)
  end
end

map('', 'gcj', 'gco', {remap = true})
map('', 'gcJ', 'gcO', {remap = true})
map('', 'as', '<cmd>normal! v<CR>s', {remap = true})
-- hjkl and word motions
map('', 'k', 'b')
map('', 'n', 'j')
map('', 'e', 'k')
map('', 'i', 'w')
map('', 'u', '<BS>')
map('', 'y', 'l')

-- Scroll and WORD motions
map('', '<C-k>', 'B')
map('', '<C-n>', '<C-d>zz')
map('', '<C-e>', '<C-u>zz')
map('', '<C-i>', 'W')

-- Normal mode into other mode
map('', 'm', 'i')
map('', 'M', 'a')
map('', 'o', 'A')
map('', 'O', 'I')
map('', 'j', 'o')
map('', 'J', 'O')

-- Visual mode
map('n', 'aa', 'V')
map('n', 'ae', 've')
map('', 'A', '<C-v>')
-- Enter visual mode with hjkl and word motions
map('n', 'K', 'vb')
map('n', 'N', 'V')
map('n', 'E', 've')
map('n', 'I', 'vw')
map('n', 'U', 'vh')
map('n', 'Y', 'vl')
-- Enter visual mode with WORD motions
map('n', '<C-M-k>', 'vB')
map('n', '<C-M-n>', 'vip')
map('n', '<C-M-e>', 'vE')
map('n', '<C-M-i>', 'vW')
-- Expand selection by hjkl and word motions
map('x', 'K', '<cmd>lua Vcheck("v", "b")<CR>')
map('x', 'N', '<cmd>lua Vcheck("V", "j")<CR>')
map('x', 'E', '<cmd>lua Vcheck("V", "k")<CR>')
map('x', 'I', '<cmd>lua Vcheck("v", "w")<CR>')
map('x', 'U', '<cmd>lua Vcheck("v", "h")<CR>')
map('x', 'Y', '<cmd>lua Vcheck("v", "l")<CR>')
-- Expand selection by hjkl and word motions
map('x', '<C-M-K>', '<cmd>lua Vcheck("v", "B")<CR>')
map('x', '<C-M-N>', '<cmd>lua Vcheck("V", "}")<CR>')
map('x', '<C-M-E>', '<cmd>lua Vcheck("V", "{")<CR>')
map('x', '<C-M-I>', '<cmd>lua Vcheck("v", "W")<CR>')
-- Copy selection and escape visual mode into hjkl and word motions
map('x', 'k', 'yb')
map('x', 'n', 'yj`>j')
map('x', 'e', 'yk')
map('x', 'i', 'yw`>')
-- Copy selection and escape visual mode into scroll and WORD motions
map('x', '<C-k>', 'y<Esc>B')
map('x', '<C-n>', 'y<C-d>zz')
map('x', '<C-e>', 'y<C-u>zz')
map('x', '<C-i>', 'y<Esc>W`>')
-- Select to / until
map('n', 'af', 'vf')
map('n', 'aF', 'vF')
map('n', 'at', 'vt')
map('n', 'aT', 'vT')
map('n', 'ao', 'v$')
map('n', 'aO', 'v^')
-- Enter visual mode with text objects
map('', 'an', 'viw')
map('', 'aN', 'viW')
map('', "a'", "vi'")
map('', 'a"', "va'of'o")
map('', 'am', 'vi"')
map('', 'aM', 'va"of"o')
map('', 'ab', 'vip')
map('', 'aB', 'vap')
map('', '(', "vib")
map('', ')', 'vab')
map('', '{', 'viB')
map('', '}', 'vaB')
map('', 'a[', 'vi[')
map('', 'a]', 'va[')

-- Delete
map('n', 'd', '"_d')
map('n', 'dd', '"_dd')
map('n', 'D', '"_dd')
map('n', 'do', '"_d$')
map('n', 'de', '"_de')
map('n', '<Del>', '"_dl')
map('x', '<Del>', '"_d')
map('n', 'dn', '"_diw')
map('n', 'dN', '"_diW')
map('', "d'", '"_di\'')
map('', 'd"', "va'of'\"_d")
map('', 'dm', '"_di"')
map('', 'dM', 'va"of""_d')
map('', 'db', '"_dip')
map('', 'dB', '"_dap')
map('', 'd(', '"_di(')
map('', 'd)', '"_da(')
map('', 'd{', '"_di{')
map('', 'd}', '"_da}')
map('', 'd[', '"_di[')
map('', 'd]', '"_da[')

-- Replace
map('', 'c', 'r')
map('', 'r', '"_c')
map('', 'rr', '"_cc')
map('', 'R', '"_cc')
map('', 'ro', '"_c$')
map('n', 're', '"_ce')
map('', 'rn', '"_ciw')
map('', 'rN', '"_ciW')
map('', "r'", '"_ci\'')
map('', 'r"', "va'of'\"_c")
map('', 'rm', '"_ci"')
map('', 'rM', 'va"of""_c')
map('', 'rb', '"_cip')
map('', 'rB', '"_cap')
map('', 'r(', '"_ci(')
map('', 'r)', '"_ca(')
map('', 'r{', '"_ci{')
map('', 'r}', '"_ca}')
map('', 'r[', "\"_ci[")
map('', 'r]', "\"_ca[")

-- Cut
map('n', 'ad', 'dd')
map('x', 'd', 'd')
map('n', 'ar', 'cc')
map('x', 'ar', 'c')

-- Paste
map('n', 'av', 'Yp')
map('x', 'av', "yj'>p")
map('n', 'v', 'p')
map('n', 'V', 'P')    -- Duplicate line
map('x', 'v', '"_dP') -- Duplicate paragraph

-- Undo
map('', 'z', 'u')
map('', 'Z', '<C-r>')

-- Search
map('n', '?', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
map('n', 'b', 'nzzzv')
map('n', 'B', 'Nzzzv')
map('', 'p', ';')
map('', 'P', ',')

-- Buffer management
map('n', '<leader>e', vim.cmd.Ex)
map('n', '<leader>w', vim.cmd.wa)
map('n', '<leader>q', vim.cmd.wqa)
map('n', 'q', vim.cmd.close)
map('n', '<leader><leader>', function()
  vim.cmd('wa')
  vim.cmd('so')
end)

-- Window navigation
map('', 'l', '<C-o>')
map('', 'L', '<C-i>')
map('', 'w', '<C-w>')
map('', 'wk', '<C-w><C-h>')
map('', 'wn', '<C-w><C-j>')
map('', 'we', '<C-w><C-k>')
map('', 'wi', '<C-w><C-l>')
map('', 'wc', '<C-w><C-n>')
map('', 'ws', '<C-w><C-s>')
map('', 'wv', '<C-w><C-v>')

-- Line management
map('v', '<M-n>', ":m '>+<CR>gv=gv")
map('v', '<M-e>', ":m '<-2<CR>gv=gv")
map('n', '<M-n>', ':m +<CR>==')
map('n', '<M-e>', ':m -2<CR>==')
map('i', '<M-n>', '<Esc>:m+<CR>==gi')
map('i', '<M-e>', '<Esc>:m-2<CR>==gi')
map('n', '<M-k>', 'mzJ`z')
map('n', '<M-i>', 'mzgJ`z')
map('', '<C-j>', 'o<Esc>')
map('', '<M-j>', 'O<Esc>')

-- Miscelaneous
map('i', '<C-e>', '<Esc>')
map('', 'a', '<nop>')
map('n', '<C-d>', '<nop>')
map('', 'Q', 'q')
map('', "<M-'>", 'm')
map('', '<CR>', ':')
map('', ';', 'mzA;<Esc>g`z')
map('', ',', 'mzA,<Esc>g`z')
-- map('n', '<leader>n', '<cmd>cnext<CR>zz')
-- map('n', '<leader>e', '<cmd>cprev<CR>zz')
-- map('n', '<leader>u', '<cmd>lnext<CR>zz')
-- map('n', '<leader>y', '<cmd>lprev<CR>zz')
map('', '+', '<C-a>')
map('', '-', '<C-x>')
map('n', '<leader>vp', '<cmd>e ~/.config/nvim/lua/me/packer.lua<CR>');
