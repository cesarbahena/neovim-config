local textobjs = {
	d = {
		desc = "Function Definition",
		treesitter = true,
		{ a = "@function.outer", i = "@function.inner" },
	},
	o = {
		desc = "Loop",
		treesitter = true,
		{ a = "@loop.outer", i = "@loop.inner" },
	},
	y = {
		desc = "Conditional",
		treesitter = true,
		{ a = "@conditional.outer", i = "@conditional.inner" },
	},
	b = {
		desc = "Block",
		treesitter = true,
		{ a = "@block.outer", i = "@block.inner" },
	},
	N = {
		desc = "Number",
		treesitter = true,
		{ a = "@number.inner", i = "@number.inner" },
	},
	["\\"] = {
		desc = "Regex",
		treesitter = true,
		{ a = "@regex.outer", i = "@regex.inner" },
	},
	["="] = {
		desc = "Assignment",
		treesitter = true,
		{ a = "@assignment.outer", i = "@assignment.inner" },
	},
	k = {
		desc = "Bracket",
		{ { "%b()", "%b[]", "%b{}" }, "^.().*().$" },
	},
	["/"] = {
		desc = "Date",
		{ "()%d+[/%-]%w+[/%-]%d+()" },
	},
	D = {
		desc = "Double bracket string",
		{ "()%[%[().-()%]%]()" },
	},
	x = {
		desc = "XML/HTML attribute",
		{ ' ()%w+="().-()"()' },
	},
	s = {
		desc = "Subword",
		{
			{
				"%u[%l%d]+%f[^%l%d]",
				"%f[%S][%l%d]+%f[^%l%d]",
				"%f[%P][%l%d]+%f[^%l%d]",
				"^[%l%d]+%f[^%l%d]",
			},
			"^().*()$",
		},
	},
}

return {
	{
		"echasnovski/mini.ai",
		event = "VeryLazy",
		opts = function(self)
			local ts = require(self.name).gen_spec.treesitter
			local custom_textobjects = {}

			for key, spec in pairs(textobjs) do
				if not spec[1] then
					break
				end

				if spec.treesitter then
					custom_textobjects[key] = ts(spec[1])
				else
					custom_textobjects[key] = spec[1]
				end
			end

			return {
				custom_textobjects = custom_textobjects,
			}
		end,

		keys = function()
			local keys = {}

			for key, spec in pairs(textobjs) do
				table.insert(keys, {
					desc = ("Next %s"):format(spec.desc),
					("]%s"):format(key),
					("van%s<Esc>"):format(key),
					remap = true,
				})

				table.insert(keys, {
					desc = ("Previous %s"):format(spec.desc),
					("[%s"):format(key),
					("val%s<Esc>"):format(key),
					remap = true,
				})
			end

			return keys
		end,
	},

	{
		"chrisgrieser/nvim-various-textobjs",
		dependencies = { "axieax/urlview.nvim" },
		event = "VeryLazy",
		opts = {
			useDefaultKeymaps = true,
			disabledKeymaps = { "n", "in", "an", "ik", "ak", "iD", "aD", "i/", "a/", "ix", "ax" },
		},
		keys = function()
			local ok, vto = pcall(require, "various-textobjs")
			if not ok then
				return
			end

			local cmd = [[<cmd>lua require("various-textobjs").%s<CR>]]
			return {
				{ desc = "Inner Variable", "iV", cmd:format("key(true)"), mode = { "o", "x" } },
				{ desc = "Outer Variable", "aV", cmd:format("key(false)"), mode = { "o", "x" } },
				{ desc = "Near EoL", ",", cmd:format("nearEoL()"), mode = { "o", "x" } },
				{
					desc = "Go to Link",
					"gl",
					function()
						vim.fn.setreg("z", "")
						vto.url()
						vim.cmd.normal({ '"zy', bang = true })
						local url = vim.fn.getreg("z")

						if url == "" then
							vim.cmd.UrlView("buffer")
							return
						end

						local opener
						if vim.fn.has("wsl") == 1 then
							opener = "wslview"
						elseif vim.fn.has("macunix") == 1 then
							opener = "open"
						elseif vim.fn.has("linux") == 1 then
							opener = "xdg-open"
						elseif vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 then
							opener = "start"
						end

						local open_cmd = string.format("%s %s >/dev/null 2>&1", opener, url)
						os.execute(open_cmd)
					end,
				},
				{
					desc = "Delete Surrounding Indentation",
					"dsi",
					function()
						vto.indentation(true, true)
						-- plugin only switches to visual mode when textobj found
						local notOnIndentedLine = vim.fn.mode():find("V") == nil
						if notOnIndentedLine then
							return
						end
						-- dedent indentation
						vim.cmd.normal({ ">", bang = true })
						-- delete surrounding lines
						local endBorderLn = vim.api.nvim_buf_get_mark(0, ">")[1] + 1
						local startBorderLn = vim.api.nvim_buf_get_mark(0, "<")[1] - 1
						vim.cmd(tostring(endBorderLn) .. " delete") -- delete end first so line index is not shifted
						vim.cmd(tostring(startBorderLn) .. " delete")
					end,
				},
			}
		end,
	},
}
