return {
	require(User .. ".ui.rosepine"),
	require(User .. ".ui.catppuccin"),
	require(User .. ".ui.devicons"),
	require(User .. ".ui.notify"),
	require(User .. ".ui.dressing"),
	{
		"lewis6991/gitsigns.nvim",
		config = require(User .. ".ui.gitsigns"),
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = require(User .. ".ui.lualine.setup"),
	},
	{
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
			require("which-key").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	},
}
