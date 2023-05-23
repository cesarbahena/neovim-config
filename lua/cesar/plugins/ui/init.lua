return {
	Plugin("ui.rosepine"),
	Plugin("ui.catppuccin"),
	Plugin("ui.devicons"),
	Plugin("ui.notify"),
	{
		"lewis6991/gitsigns.nvim",
		config = Plugin("ui.gitsigns"),
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = Plugin("ui.lualine.setup"),
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
