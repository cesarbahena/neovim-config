return {
	{
		"folke/trouble.nvim",
		opts = {
			position = "right",
			action_keys = {
				close = { "q", "<C-e>" },
				hover = "?",
				previous = { "e", "k" },
				next = { "n", "j" },
				jump_close = "y",
			},
		},
		cmd = "TroubleToggle",
		keys = {
			{ desc = "Toggle document diagnostics", "cd", "<cmd>TroubleToggle document_diagnostics<cr>" },
			{ desc = "Toggle workspace diagnostics", "<leader>cd", "<cmd>TroubleToggle workspace_diagnostics<cr>" },
			{ desc = "Toggle quickfix list", "<leader>xc", "<cmd>TroubleToggle quickfix<cr>" },
			{ desc = "Toggle location list", "<leader>xd", "<cmd>TroubleToggle loclist<cr>" },
			{ "gr" },
		},
		config = function(_, opts)
			local trouble = require("trouble")
			trouble.setup(opts)

			local keymaps = require(User .. ".config.keymaps")
			require(User .. ".config.autocmd")({
				"Filetype",
				"Trouble",
				pattern = "Trouble",
				function()
					keymaps({
						n = {
							{
								"Next item (skip groups)",
								{ colemak = "n", qwerty = "j" },
								function()
									trouble.next({ skip_groups = true })
								end,
							},
							{
								"Previous item (skip groups)",
								{ colemak = "e", qwerty = "k" },
								function()
									trouble.previous({ skip_groups = true })
								end,
							},
							{
								"First item",
								{ colemak = "N", qwerty = "J" },
								function()
									trouble.first({ skip_groups = true })
								end,
							},
							{
								"Last item",
								{ colemak = "E", qwerty = "K" },
								function()
									trouble.last({ skip_groups = true })
								end,
							},
						},
					}, { buffer = true })
				end,
			})
		end,
	},
}
