local augroup = vim.api.nvim_create_augroup
local TrimTrailingSpace = augroup('TrimTrailingSpace', {})

local autocmd = vim.api.nvim_create_autocmd

autocmd({"BufWritePre"}, {
    group = TrimTrailingSpace,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})
