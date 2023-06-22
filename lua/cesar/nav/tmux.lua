return {
	{
		"aserowy/tmux.nvim",
		keys = function()
			local installed, tmux = pcall(require, "tmux")
			local term = vim.env.TERM
			if installed then
				return {
					{ desc = "Navigate to window/tmux pane to the left", "<M-m>", tmux.move_left },
					{ desc = "Navigate to window/tmux pane below", "<M-n>", tmux.move_bottom },
					{ desc = "Navigate to window/tmux pane above", "<M-e>", tmux.move_top },
					{ desc = "Navigate to window/tmux pane to the right", "<M-o>", tmux.move_right },
					{ desc = "Resize window/tmux pane left", "<C-M-m>", tmux.resize_left },
					{ desc = "Resize window/tmux pane down", "<C-M-n>", tmux.resize_bottom },
					{ desc = "Resize window/tmux pane up", "<C-M-e>", tmux.resize_top },
					{ desc = "Resize window/tmux pane right", "<C-M-o>", tmux.resize_right },
				}
			end
		end,
		opts = {
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
		},
	},
	{
		"folke/zen-mode.nvim",
		keys = function()
			local installed, zen_mode = pcall(require, "zen-mode")
			if installed then
				return {
					{ desc = "Zen mode", "<M-z>", zen_mode.toggle, mode = "" },
				}
			end
		end,
		config = true,
	},
}
