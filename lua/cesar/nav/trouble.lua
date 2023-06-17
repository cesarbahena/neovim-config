return {
	{
		"folke/trouble.nvim",
		cmd = "TroubleToggle",
		opts = {
			position = "right",
			action_keys = {
				close = { "q", "<C-e>" },
				hover = "?",
				previous = { "e", "k" },
				next = { "n", "j" },
			},
		},
		config = function(_, opts)
			require("trouble").setup(opts)
			require(User .. ".config.keymaps")({
				[""] = {
					{ "Toggle quickfix list", "<leader>xc", "<cmd>TroubleToggle quickfix<cr>" },
					{ "Toggle location list", "<leader>xC", "<cmd>TroubleToggle quickfix<cr>" },
					{ "Toggle workspace diagnostics", "<leader>xd", "<cmd>TroubleToggle workspace_diagnostics<cr>" },
					{ "Toggle document diagnostics", "<leader>xD", "<cmd>TroubleToggle document_diagnostics<cr>" },
				},
			})
		end,
	},
}
