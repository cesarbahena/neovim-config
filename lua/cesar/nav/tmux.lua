return {
	{
		"aserowy/tmux.nvim",
		config = function()
			require("tmux").setup({
				copy_sync = {
					redirect_to_clipboard = true,
					sync_clipboard = true,
				},
				navigation = {
					enable_default_keybindings = false,
				},
				resize = {
					enable_default_keybindings = false,
				},
			})

			local keymaps = require(User .. ".config.keymaps")
			local tmux = require("tmux")
			keymaps({
				[""] = {
					{ "Navigate to window/tmux pane to the left", "<M-m>", tmux.move_left },
					{ "Navigate to window/tmux pane down", "<M-n>", tmux.move_bottom },
					{ "Navigate to window/tmux pane up", "<M-e>", tmux.move_top },
					{ "Navigate to window/tmux pane to the right", "<M-o>", tmux.move_right },
					{ "Resize window/tmux pane left", "<C-M-m>", tmux.resize_left },
					{ "Resize window/tmux pane down", "<C-M-n>", tmux.resize_bottom },
					{ "Resize window/tmux pane up", "<C-M-e>", tmux.resize_top },
					{ "Resize window/tmux pane right", "<C-M-o>", tmux.resize_right },
					{ "Move window to leftmost side", "<C-w>m", "<C-w>H" },
					{ "Move window to bottom", "<C-w>n", "<C-w>J" },
					{ "Move window to top", "<C-w>e", "<C-w>K" },
					{ "Move window to rightmost side", "<C-w>o", "<C-w>L" },
					{ "Move window to leftmost side", "<C-w><C-m>", "<C-w>H" },
					{ "Move window to bottom", "<C-w><C-n>", "<C-w>J" },
					{ "Move window to top", "<C-w><C-e>", "<C-w>K" },
					{ "Move window to rightmost side", "<C-w><C-o>", "<C-w>L" },
				},
			})
		end,
	},
}
