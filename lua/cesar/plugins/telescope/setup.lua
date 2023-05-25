return function()
	Plugin("telescope.finders")
	local actions = require("telescope.actions")
	require("telescope").setup({
		defaults = {
			sorting_strategy = "ascending",
			layout_strategy = "center",
			color_devicons = true,
			history = {
				path = "~/.local/share/nvim/databases/telescope_history.sqlite3",
			},
			mappings = {
				i = {
					["<C-e>"] = "close",
					["<RightMouse>"] = "close",
					["<LeftMouse>"] = "select_default",
					["<ScrollWheelDown>"] = "move_selection_next",
					["<ScrollWheelUp>"] = "move_selection_previous",
					["<C-x>"] = false,
					["<C-y>"] = "select_default",
					-- ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
					-- ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					["<C-h>"] = "cycle_history_next",
					["<C-k>"] = "cycle_history_prev",
					["<C-g>s"] = "select_all",
					["<C-g>a"] = "add_selection",
				},
			},
		},
	})
end
