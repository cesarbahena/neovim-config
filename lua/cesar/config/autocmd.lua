local function autocmd(args)
	local event = args[1]
	local buffer = args[4]

	local group
	if args.clear == false then
		group = vim.api.nvim_create_augroup(args[2], { clear = false })
	else
		group = vim.api.nvim_create_augroup(args[2], {})
	end

	local callback, command
	if type(args[3]) == "function" then
		callback = args[3]
	else
		command = args[3]
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

-- User autocommands
autocmd({
	"BufEnter",
	"SetOptions",
	"setlocal cpoptions=aABceFIs_ formatoptions=crqj",
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
})

autocmd({
	"QuitPre",
	"UnsavedChanges",
	function()
		if vim.o.modified then
			Modified = true
			vim.defer_fn(function()
				Modified = false
			end, 5000)
		end
	end,
})

local keymaps = require(User .. ".config.keymaps")

autocmd({
	"FileType",
	"QuickFixList",
	pattern = "qf",
	function()
		keymaps({
			n = {
				{ "Close", "<C-e>", vim.cmd.q },
				{ "Go to file", "<CR>", "<CR>" },
			},
		}, { buffer = true })
	end,
})

autocmd({
	"FileType",
	"CloseOnCancel",
	pattern = { "help", "notify", "noice", "lazy", "Trouble" },
	function()
		keymaps({
			n = {
				{ "Disabled", "<C-n>", "<nop>" },
				{ "Close", "<C-e>", vim.cmd.q },
				{ "Disabled", "<C-i>", "<nop>" },
				{ "Disabled", "<C-o>", "<nop>" },
			},
		}, { buffer = true })
	end,
})

return autocmd
