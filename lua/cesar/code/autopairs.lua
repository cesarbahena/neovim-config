return {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			check_ts = true,
			fast_wrap = {
				map = "<C-a>",
				end_key = "o",
				keys = "neirstqwfpluy;",
				highlight = "PmenuSel",
				highlight_grey = "LineNr",
			},
		},
	},
	{
		"tpope/vim-surround",
		event = "VeryLazy",
		dependencies = { "tpope/vim-repeat" },
	},
}
