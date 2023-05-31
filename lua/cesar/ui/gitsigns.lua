return function()
	local signs = require("gitsigns")

	vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "green", bold = true })
	vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "orange", bold = true })
	vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "red", bold = true })

	signs.setup({
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

		keymaps = {
			-- Default keymap options
			noremap = true,
			buffer = true,
			["n ]h"] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'" },
			["n [h"] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'" },
			-- ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
			-- ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
			-- ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
			-- ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
			-- ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line()<CR>',
		},
		current_line_blame_opts = {
			delay = 2000,
			virt_text_pos = "eol",
		},
	})
end
