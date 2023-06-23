vim.keymap.set("n", "<space>", "<nop>")

local function keymaps(table_of_keymaps, shared_opts)
	for mode, mode_keymaps in pairs(table_of_keymaps) do
		for _, keymap in ipairs(mode_keymaps) do
			local lhs = keymap[2]
			if type(lhs) == "table" then
				lhs = lhs[Keyboard]
			end

			local rhs = keymap[3]

			local opts = keymap[4] or {}
			if shared_opts then
				opts = vim.tbl_deep_extend("force", shared_opts, opts)
			end
			opts.desc = keymap[1]

			if lhs then
				vim.keymap.set(mode, lhs, rhs, opts)
			else
				vim.keymap.set(mode, rhs, rhs, opts)
			end
		end
	end
end

keymaps({
	[""] = {
		{ "Cmdline mode", "<CR>", ":" },
		{ "Open new Line below", { colemak = "l" }, "o" },
		{ "Open new Line above", { colemak = "L" }, "O" },
		{ "Substitute (same as change)", "s", "c" },
		{ "Next line", { colemak = "n" }, "j" },
		{ "Scroll to Next page", { colemak = "N", qwerty = "J" }, "<C-d>zz" },
		{ "prEv line", { colemak = "e" }, "k" },
		{ "Scroll to prEv line", { colemak = "E", qwerty = "K" }, "<C-u>zz" },
		{ "bacK one word", { colemak = "k" }, "b" },
		{ "bacK one WORD", { colemak = "K" }, "B" },
		{ "Word (rest of it)", "w", "e" },
		{ "WORD (rest of it)", "W", "E" },
		{ "Hop to next word", { colemak = "h", qwerty = "n" }, "w" },
		{ "Hop to next WORD", { colemak = "H", qwerty = "N" }, "W" },
		{ "Left", { colemak = "m" }, "h" },
		{ "Right", { colemak = "o" }, "l" },
		{ "HoMe (first non whitespace char)", { colemak = "M", qwerty = "H" }, "^" },
		{ "EOL", { colemak = "O", qwerty = "L" }, "$" },
		{ "Mark", { colemak = "j" }, "m" },
		{ "Next match", "\\", "n" },
		{ "Delete into void register", "x", [["_x]] },
		{ "Quit", "<M-q>", vim.cmd.q },
	},

	n = {
		{ "Delete to eol", "dd", "D" },
		{ "Substitute to eol (same as change)", "ss", "C" },
		{ "Yank line", "Y", "yy" },
		{ "Yank to eol", "yy", "y$" },
		{ "Yank to clipboard", "<leader>y", [["+y]] },
		{ "Yank line to clipboard", "<leader>Y", [["+yy]] },
		{ "Paste from clipboard", "<leader>p", [["+P]] },
		{ "Paste from clipboard in new line", "<leader>P", [[o<Esc>"+p]] },
		{ "Copy down", "yp", "Yp" },
		{ "Redo", "U", "<C-r>" },
		{ "Undo last jump", { colemak = "<C-u>", qwerty = "<C-i>" }, "<C-o>" },
		{ "Redo last jump", { colemak = "<C-y>", qwerty = "<C-o>" }, "<C-i>" },
		{ "Insert comma at the end", { colemak = ",k", qwerty = ",n" }, "mzA,<Esc>`z" },
		{ "Insert semicolon at the end", { colemak = ",h", qwerty = ",m" }, "mzA;<Esc>`z" },
		{ "Insert comma at the end", ",d", "mz$x`z" },
		{ "Move line down", "<C-c>", ":m +<CR>==" },
		{ "Move line up", "<C-s>", ":m -2<CR>==" },
		{ "Join/Merge lines (pretty)", { colemak = "J", qwerty = "M" }, "mzJ`z" },
		{ "Join/Merge lines (raw)", { colemak = "gJ", qwerty = "gM" }, "mzgJ`z" },
		{ "Navigate to window to the left", "<C-w>m", "<C-w>h" },
		{ "Navigate to window below", "<C-w>n", "<C-w>j" },
		{ "Navigate to window above", "<C-w>e", "<C-w>k" },
		{ "Navigate to window to the right", "<C-w>o", "<C-w>l" },
		{ "Move window to leftmost side", "<C-w>m", "<C-w>H" },
		{ "Move window to top", "_", "<C-w>K" },
		{ "Move window to bottom", "<leader>_", "<C-w>J" },
		{ "Move window to leftmost side", "|", "<C-w>H" },
		{ "Move window to rightmost side", "<leader>|", "<C-w>L" },
		{ "Evenly distributed windows", "<leader>=", "<C-w>=" },
		{
			"Replace current word",
			"<leader>s",
			":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
		},
		{
			"Insert mode (indent blankline)",
			"i",
			function()
				if #vim.fn.getline(".") == 0 then
					return [["_cc]]
				else
					return "i"
				end
			end,
			{ expr = true },
		},
		{
			"Delete line (don't yank blankline)",
			"D",
			function()
				if vim.api.nvim_get_current_line():match("^%s*$") then
					return '"_dd'
				else
					return "dd"
				end
			end,
			{ expr = true },
		},
	},

	v = {
		{ "Escape to normal mode", { colemak = "<C-e>", qwerty = "<C-k>" }, "<Esc>" },
		{ "Yank (keep position)", "y", "y`>" },
		{ "Yank to clipboard (keep position)", "<leader>y", [["+y`>]] },
		{ "Paste (w/o cutting)", "p", "P" },
		{ "Paste from clipboard (w/o cutting)", "<leader>p", [["+P]] },
		{
			"Change visual mode",
			"V",
			function()
				if vim.fn.mode():find("V") then
					return "v"
				end
				return "V"
			end,
			{ expr = true },
		},
	},

	i = {
		{ "Escape to normal mode", { colemak = "<C-e>", keymaps = "<C-k>" }, "<Esc>" },
		{ "Paste from clipboard", "<C-p>", [[<C-o>"+P]] },
		{ "Left", "<C-r>", "<Left>" },
		{ "Right", "<C-d>", "<Right>" },
		{ "Comma after bracket", { colemak = "<C-k>", qwerty = "<C-b>" }, ".<Esc>mzva{lva,<Esc>`za<BS>" },
		{ "Semicolon after bracket", { colemak = "<C-h>", qwerty = "<C-b>" }, ".<Esc>mzva{lva;<Esc>`za<BS>" },
		{ "Auto undo breakpoints", ",", ",<C-g>u" },
		{ "Auto undo breakpoints", ";", ";<C-g>u" },
		{ "Auto undo breakpoints", ".", ".<C-g>u" },
	},

	c = {
		{ "Escape to normal mode", { colemak = "<C-e>", qwerty = "<C-k>" }, "<Esc>" },
	},
})

return keymaps
