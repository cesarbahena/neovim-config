return function()
	require("nvim-treesitter.configs").setup({
		ensure_installed = {
			"javascript",
			"typescript",
			"lua",
			"vim",
			"python",
			"regex",
			"bash",
			"markdown",
			"markdown_inline",
		},
		auto_install = true,
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				node_incremental = "v",
				scope_incremental = "C",
				node_decremental = "D",
			},
		},
		indent = {
			enable = true,
		},
		textobjects = {
			swap = {
				enable = true,
				swap_next = {
					["<C-h>"] = "@parameter.inner",
				},
				swap_previous = {
					["<C-k>"] = "@parameter.inner",
				},
			},
			lsp_interop = {
				enable = true,
				floating_preview_opts = {
					border = "rounded",
				},
				peek_definition_code = {
					["<C-f>"] = "@function.outer",
					["<leader>dc"] = "@class.outer",
				},
			},
		},
	})

	local keymaps = require(User .. ".config.keymaps")
	keymaps({
		i = {
			{
				"Move outside syntactical region",
				"<C-o>",
				"<Esc><cmd>normal vvv<cr>A",
			},
		},
	})
end
