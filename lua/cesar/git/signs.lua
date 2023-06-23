return {
	"lewis6991/gitsigns.nvim",
	event = "VeryLazy",
	opts = {
		signs = {
			add = { hl = "GitSignsAdd", text = "▎" },
			change = { hl = "GitSignsChange", text = "▎" },
			delete = { hl = "GitSignsDelete", text = "" },
			topdelete = { hl = "GitSignsDelete", text = "" },
			changedelete = { hl = "GitSignsDelete", text = "▎" },
			untracked = { text = "" },
		},
		-- Highlights just the number part of the number column
		numhl = false,
		-- Highlights the _whole_ line.
		--    Instead, use gitsigns.toggle_linehl()
		linehl = false,
		-- Highlights just the part of the line that has changed
		--    Instead, use gitsigns.toggle_word_diff()
		word_diff = false,
		current_line_blame_opts = {
			delay = 2000,
			virt_text_pos = "eol",
		},
	},
	config = function(_, opts)
		require("gitsigns").setup(opts)
		vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "green", bold = true })
		vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "orange", bold = true })
		vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "red", bold = true })
	end,
}
