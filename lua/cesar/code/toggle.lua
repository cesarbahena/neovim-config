return {
	{
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		opts = {
			toggler = { line = "C", block = "gC" },
			opleader = { line = "c", block = "gc" },
			extra = { above = "cL", below = "cl", eol = "cc" },
			mappings = { basic = true, extra = true },
		},
	},
	{
		"Wansmer/treesj",
		dependencies = {
			"AndrewRadev/switch.vim",
		},
		opts = {
			use_default_keymaps = false,
		},
		keys = function(self)
			local installed, tsj = pcall(require, self.name)
			if not installed then
				return
			end

			return {
				{
					desc = "Toggle split/join",
					"-",
					function()
						local plugins = vim.api.nvim_list_runtime_paths()
						local switch_installed = false
						for _, plugin in ipairs(plugins) do
							if plugin == "/home/cesar/.local/share/nvim/lazy/switch.vim" then
								switch_installed = true
								break
							end
						end

						if not switch_installed then
							tsj.toggle()
							return
						end

						local cursor = vim.api.nvim_win_get_cursor(0)
						if type(cursor) ~= "table" then
							return
						end

						local lines = vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], false)
						if type(lines) ~= "table" then
							return
						end

						local line = lines[1]
						if type(line) ~= "string" then
							return
						end

						local character = line:sub(cursor[2] + 1, cursor[2] + 1)
						if character:match("%A") then
							tsj.toggle()
							return
						end

						local string = line:sub(cursor[2] - 3, cursor[2] + 5)
						if string:match("true") or string:match("false") then
							vim.cmd("Switch")
							return
						end
						tsj.toggle()
					end,
				},
			}
		end,
	},
}
