return function()
	Plugin("telescope.finders")
	local actions = require("telescope.actions")
	require("telescope").setup({
		defaults = {
			prompt_prefix = "> ",
			-- selection_caret = "> ",
			-- entry_prefix = "  ",
			-- multi_icon = "<>",
			sorting_strategy = "ascending",
			color_devicons = true,
			history = {
				path = "~/.local/share/nvim/databases/telescope_history.sqlite3",
			},
			mappings = {
				i = {
					["<C-e>"] = actions.close,
					["<RightMouse>"] = actions.close,
					["<LeftMouse>"] = actions.select_default,
					["<ScrollWheelDown>"] = actions.move_selection_next,
					["<ScrollWheelUp>"] = actions.move_selection_previous,
					["<C-x>"] = false,
					-- ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
					-- ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					["<C-h>"] = actions.cycle_history_next,
					["<C-k>"] = actions.cycle_history_prev,
					["<C-g>s"] = actions.select_all,
					["<C-g>a"] = actions.add_selection,
				},
			},
		},
		extensions = {
			dap = {
				theme = "dropdown",
			},
		},
	})
end
