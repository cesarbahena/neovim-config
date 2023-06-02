return function()
	local keymap = require(User .. ".config.mappings")
	local autocmd = require(User .. ".config.autocmd")

	keymap({
		[""] = {
			{
				"Git status",
				"gs",
				function()
					vim.cmd("vert Git")
				end,
			},
		},
	})

	autocmd({
		"BufWinEnter",
		"Fugitive",
		function()
			if vim.bo.ft ~= "fugitive" then
				return
			end
			keymap({
				[""] = {
					{
						"Git push",
						"<leader>p",
						function()
							vim.cmd.Git("push")
						end,
					},
					{ "Git push", "<leader>gp", ":Git push -u origin" },
					{
						"Git pull",
						"<leader>P",
						function()
							vim.cmd.Git("pull")
						end,
					},
					{ "Close", "<C-e>", vim.cmd.q },
				},
			}, { buffer = true })
		end,
	})
end
