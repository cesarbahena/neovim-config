return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{
				"rcarriga/nvim-dap-ui",
				opts = {
					mappings = {
						edit = "i",
					},
					expand_lines = true,
					layouts = {
						{
							elements = {
								"scopes",
								"stacks",
							},
							size = 40,
							position = "right",
						},
						{
							elements = {
								"repl",
								"watches",
								"breakpoints",
							},
							size = 0.25,
							position = "bottom",
						},
					},
					floating = {
						border = "rounded",
						mappings = {
							close = { "q", "<C-e>" },
						},
					},
				},
			},
		},
		config = require(User .. ".dap.keymaps"),
	},
	require(User .. ".dap.vscodejs"),
	{
		"theHamsta/nvim-dap-virtual-text",
		config = function()
			require("nvim-dap-virtual-text").setup({
				enabled = true,
				-- DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, DapVirtualTextForceRefresh
				enabled_commands = false,
				-- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
				highlight_changed_variables = true,
				highlight_new_as_changed = true,
				-- prefix virtual text with comment string
				commented = false,
				show_stop_reason = true,
				-- experimental features:
				virt_text_pos = "eol", -- position of virtual text, see `:h nvim_buf_set_extmark()`
			})
		end,
	},
}
