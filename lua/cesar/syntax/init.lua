return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		commit = "aa44e5f", -- Workaround for a bug
		config = require(User .. ".syntax.treesitter"),
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
	},
	"nvim-treesitter/nvim-treesitter-context",
	"nvim-treesitter/playground",
	"tpope/vim-surround",
	{ "windwp/nvim-autopairs", config = true },
	{
		"chrisgrieser/nvim-various-textobjs",
		dependencies = {
			"axieax/urlview.nvim",
		},
		config = require(User .. ".syntax.various_textobjs"),
	},
	require(User .. ".syntax.comment"),
}
