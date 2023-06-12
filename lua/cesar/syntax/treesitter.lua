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
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["iB"] = "@block.inner",
					["aB"] = "@block.outer",
					["ic"] = "@class.inner",
					["ac"] = "@class.outer",
					["iy"] = "@conditional.inner",
					["ay"] = "@conditional.outer",
					["id"] = "@function.inner",
					["ad"] = "@function.outer",
					["io"] = "@loop.inner",
					["ao"] = "@loop.outer",
					["i#"] = "@number.inner",
					["a#"] = "@number.inner",
					["i/"] = "@regex.inner",
					["a/"] = "@regex.outer",
				},
			},
			swap = {
				enable = true,
				swap_next = {
					["<leader>o"] = "@parameter.inner",
				},
				swap_previous = {
					["<leader>m"] = "@parameter.inner",
				},
			},
			lsp_interop = {
				enable = true,
				floating_preview_opts = {
					border = "rounded",
				},
				peek_definition_code = {
					["<C-s>"] = "@function.outer",
					["<leader>dc"] = "@class.outer",
				},
			},
			-- move = {
			-- 	enable = true,
			-- 	set_jumps = true,
			-- 	goto_next_start = {
			-- 		["]="] = "@assignment.outer",
			-- 		["]a"] = "@argument.outer",
			-- 		["]A"] = "@attribute.outer",
			-- 		["]b"] = "@block.outer",
			-- 		["]F"] = "@call.outer",
			-- 		["]C"] = "@class.outer",
			-- 		["]c"] = "@conditional.outer",
			-- 		["]/"] = "@comment.outer",
			-- 		["]f"] = "@function.outer",
			-- 		["]l"] = "@loop.outer",
			-- 		["]n"] = "@number.inner",
			-- 		["]r"] = "@return.outer",
			-- 	},
			-- },
		},
	})
end
