return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			presets = {
				command_palette = true,
				lsp_doc_border = true,
			},
			routes = {
				{
					view = "notify",
					filter = {
						event = "msg_show",
						find = "No write since last change",
					},
					opts = { skip = true },
				},
				{
					view = "notify",
					filter = {
						event = "msg_show",
						find = "nvim_win_call",
					},
					opts = { skip = true },
				},
				{
					view = "notify",
					filter = {
						event = "msg_show",
						find = "ModeChanged Autocommands",
					},
					opts = { skip = true },
				},
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
			{
				"rcarriga/nvim-notify",
				keys = function()
					local installed, notify = pcall(require, "notify")
					if installed then
						return {
							{ desc = "Dismiss", "<leader>e", notify.dismiss },
						}
					end
				end,
				opts = { background_colour = "#000000" },
			},
		},
	},
}
