local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local TrimTrailingSpace = augroup("TrimTrailingSpace", {})
autocmd({ "BufWritePre" }, {
	group = TrimTrailingSpace,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

local yank_group = augroup("HighlightYank", {})
autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})
