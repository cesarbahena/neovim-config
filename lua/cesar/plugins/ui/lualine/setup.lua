return function()
	require("lualine").setup({
		options = {
			theme = "catppuccin",
			component_separators = "",
			section_separators = "",
		},
		sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = {
				Plugin("ui.lualine.file_info").cwd,
				Plugin("ui.lualine.file_info").git,
				Plugin("ui.lualine.file_info").filetype,
				Plugin("ui.lualine.file_info").filename,
				Plugin("ui.lualine.file_info").write_status,
			},
			lualine_x = {
				{
					function()
						return vim.g.keyboard
					end,
					icon = " ",
				},
				Plugin("ui.lualine.services").linters,
				Plugin("ui.lualine.services").formatters,
				Plugin("ui.lualine.services").lsp,
			},
			lualine_y = {},
			lualine_z = {},
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_y = {},
			lualine_z = {},
			lualine_c = {},
			lualine_x = {},
		},
	})
end
