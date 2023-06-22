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
			require("trouble").setup(opts)
			require(User .. ".config.autocmd")({
				"Filetype",
				"Trouble",
				pattern = "Trouble",
				function() end,
			})
		end,
	},
}
