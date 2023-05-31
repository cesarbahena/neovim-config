return {
	{
		"hrsh7th/nvim-cmp",
		config = function()
			require(User .. ".cmp.mappings")
			require(User .. ".cmp.setup")
		end,
	},
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-nvim-lua",
	"hrsh7th/cmp-nvim-lsp",
	"tamago324/cmp-zsh",
	require(User .. ".cmp.ui"),
	require(User .. ".cmp.snips.init"),
	"rafamadriz/friendly-snippets",
	{
		"zbirenbaum/copilot.lua",
		config = true,
	},
	{
		"zbirenbaum/copilot-cmp",
		config = true,
	},
}
