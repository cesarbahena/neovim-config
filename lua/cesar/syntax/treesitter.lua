return function()
	require("nvim-treesitter.configs").setup({
		ensure_installed = {
			"javascript",
			"typescript",
			"lua",
			"python",
		},
		auto_install = true,
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "gn",
				node_incremental = "gn",
				scope_incremental = "ge",
				node_decremental = "gm",
      },
      indent = {
        enable = true
      },
    }
  })
end
