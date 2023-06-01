return function()
	local telescope = require("telescope")
	require(User .. ".nav.finders")

	telescope.setup({
		defaults = {
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
					["<C-h>"] = "cycle_history_next",
					["<C-k>"] = "cycle_history_prev",
					["<C-g>s"] = "select_all",
					["<C-g>a"] = "add_selection",
				},
			},
		},
		extensions = {
			file_browser = {
				theme = "ivy",
				hijack_netrw = true,
				hidden = true,
			},
		},
	})

	local extensions = {
		"fzf",
		"neoclip",
		"frecency",
		"file_browser",
		"projects",
		"ui-select",
		"notify",
	}

	for _, extension in ipairs(extensions) do
		telescope.load_extension(extension)
	end
end
