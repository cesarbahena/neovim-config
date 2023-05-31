return {
	require(User .. ".ui.rosepine"),
	require(User .. ".ui.catppuccin"),
	require(User .. ".ui.devicons"),
	require(User .. ".ui.notify"),
	require(User .. ".ui.dressing"),
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = require(User .. ".ui.lualine.setup"),
	},
}
