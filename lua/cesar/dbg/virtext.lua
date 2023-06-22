return {
	{
		"theHamsta/nvim-dap-virtual-text",
		dependecies = {
			"mfussenegger/nvim-dap",
		},
		opts = {
			{
				enabled_commands = false,
				highlight_changed_variables = true,
				show_stop_reason = true,
			},
		},
	},
}
