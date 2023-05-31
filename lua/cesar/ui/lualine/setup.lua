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
				require(User .. ".ui.lualine.file_info").cwd,
				require(User .. ".ui.lualine.file_info").git,
				require(User .. ".ui.lualine.file_info").filetype,
				require(User .. ".ui.lualine.file_info").filename,
				require(User .. ".ui.lualine.file_info").write_status,
			},
			lualine_x = {
				{
					function()
						return Keyboard
					end,
					icon = " ",
				},
				require(User .. ".ui.lualine.services").linters,
				require(User .. ".ui.lualine.services").formatters,
				require(User .. ".ui.lualine.services").lsp,
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
