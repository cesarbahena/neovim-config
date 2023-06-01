local function autocmd(args)
	local event = args[1]
	local clear = args.clear or false
	local group = vim.api.nvim_create_augroup(args[2], { clear = clear })
	local buffer = args[4]

	local callback, command
	if type(args[3]) == "function" then
		callback = args[3]
	else
		command = args[3]
	end

	if args.clear then
		vim.api.nvim_clear_autocmds({
			group = group,
			buffer = buffer,
		})
	end

	vim.api.nvim_create_autocmd(event, {
		group = group,
		callback = callback,
		command = command,
		buffer = buffer,
		pattern = args.pattern,
		once = args.once,
	})
end

autocmd({
	"BufWritePre",
	"TrimTrailingSpace",
	function()
		vim.cmd([[%s/\s\+$//e]])
	end,
	pattern = "*",
	clear = true,
})

autocmd({
	"TextYankPost",
	"HighlightYank",
	function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
	pattern = "*",
})

return autocmd
