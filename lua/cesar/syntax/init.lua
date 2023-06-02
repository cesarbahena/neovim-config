return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = require(User .. ".syntax.treesitter"),
	},
	"nvim-treesitter/nvim-treesitter-context",
	"nvim-treesitter/playground",
	require(User .. ".syntax.comment"),
	"tpope/vim-surround",
	{ "windwp/nvim-autopairs", config = true },
}
