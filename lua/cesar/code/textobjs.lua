return {
	{
		"echasnovski/mini.ai",
		event = "VeryLazy",
		opts = function(self)
			local ts = require(self.name).gen_spec.treesitter
			return {
				custom_textobjects = {
					k = { { "%b()", "%b[]", "%b{}" }, "^.().*().$" },
					d = ts({ a = "@function.outer", i = "@function.inner" }),
					o = ts({ a = "@loop.outer", i = "@loop.inner" }),
					y = ts({ a = "@conditional.outer", i = "@conditional.inner" }),
					b = ts({ a = "@block.outer", i = "@block.inner" }),
					N = ts({ a = "@number.inner", i = "@number.inner" }),
					["/"] = ts({ a = "@regex.outer", i = "@regex.inner" }),
					["="] = ts({ a = "@assignment.outer", i = "@assignment.inner" }),
				},
				around_next = "ah",
				inside_next = "ih",
			}
		end,
	},
	{
		"chrisgrieser/nvim-various-textobjs",
		dependencies = { "axieax/urlview.nvim" },
		event = "VeryLazy",
		opts = {
			useDefaultKeymaps = true,
			disabledKeymaps = { "n", "in", "an", "ik", "ak" },
		},
		keys = function()
			local vto = [[<cmd>lua require("various-textobjs").%s<CR>]]
			return {
				{ desc = "Next Subword", "<leader>h", "v" .. vto:format("subword(false)") .. "vl" },
				{ desc = "Next Subword", "<leader>k", "hv" .. vto:format("subword(false)") .. "ov" },
				{
					desc = "Inner Subword",
					"<leader>w",
					vto:format("subword(true)"),
					mode = { "o", "x" },
				},
				{
					desc = "Outer SubWORD",
					"<leader>W",
					vto:format("subword(false)"),
					mode = { "o", "x" },
				},
				{ desc = "Inner Variable", "iV", vto:format("key(true)"), mode = { "o", "x" } },
				{ desc = "Outer Variable", "aV", vto:format("key(false)"), mode = { "o", "x" } },
				{
					desc = "Near EoL",
					",",
					vto:format("nearEoL()"),
					mode = { "o", "x" },
				},
				{
					desc = "Go to Link",
					"gl",
					function()
						vim.fn.setreg("z", "")
						require("various-textobjs").url()
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
						require("various-textobjs").indentation(true, true)
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
