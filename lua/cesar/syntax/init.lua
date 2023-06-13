return {
	-- Treesitter
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

	-- Utils
	{ "windwp/nvim-autopairs", config = true },
	{
		"tpope/vim-surround",
		dependencies = { "tpope/vim-repeat" },
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		opts = {
			char = "",
			show_current_context = true,
		},
	},
	require(User .. ".syntax.comment"),
	require(User .. ".syntax.ts_join"),

	-- Textobjects
	require(User .. ".syntax.mini_ai"),
	require(User .. ".syntax.various_textobjs"),
}
