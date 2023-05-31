return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = { "javascript", "typescript", "c", "lua", "rust" },
			sync_install = false,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
		},
	},
	"nvim-treesitter/nvim-treesitter-context",
	"nvim-treesitter/playground",
	require(User .. ".syntax.comment"),
	"tpope/vim-surround",
  { 'windwp/nvim-autopairs', config = true },
}
