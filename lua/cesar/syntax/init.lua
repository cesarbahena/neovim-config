return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = require(User .. ".syntax.treesitter"),
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
	},
	-- "nvim-treesitter/nvim-treesitter-context",
	"nvim-treesitter/playground",
	"tpope/vim-surround",
	{ "windwp/nvim-autopairs", config = true },
	{
		"chrisgrieser/nvim-various-textobjs",
		config = require(User .. ".syntax.various_textobjs"),
	},
	require(User .. ".syntax.comment"),
}
