require('me.remap')
require('me.set')

local augroup = vim.api.nvim_create_augroup
local TrimTrailingSpace = augroup('TrimTrailingSpace', {})

local autocmd = vim.api.nvim_create_autocmd

autocmd({"BufWritePre"}, {
    group = TrimTrailingSpace,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

vim.g.netrw_browse_split = 0
-- vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
