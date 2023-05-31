return {
  {
    "tpope/vim-fugitive",
    config = require(User .. ".git.fugitive")
  },
	{
		"lewis6991/gitsigns.nvim",
		config = require(User .. ".git.signs"),
	},
  {
    "mbbill/undotree",
    keys = {
      { '<leader>u', '<cmd>UndotreeToggle<CR><C-w><C-h><C-w><C-k>'}
    }
  },
}
