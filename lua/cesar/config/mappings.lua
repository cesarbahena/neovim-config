vim.keymap.set("n", "<space>", "<nop>")
vim.keymap.set("n", "<leader>ft", "<cmd>Explore<CR><CR>")

local function keymap(table_of_remaps, shared_opts)
	for mode, remaps in pairs(table_of_remaps) do
		for _, remap in ipairs(remaps) do
			local lhs = remap[2]
			if type(lhs) == "table" then
				lhs = lhs[Keyboard]
			end

			local rhs = remap[3]

			local opts = remap[4] or {}
			if shared_opts then
				opts = vim.tbl_deep_extend("force", shared_opts, opts)
			end
			opts.desc = remap[1]

			if lhs then
				vim.keymap.set(mode, lhs, rhs, opts)
			else
				vim.keymap.set(mode, rhs, rhs, opts)
			end
		end
	end
end

keymap({
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
		{ "Next match", "|", "N" },
		{ "Increase count", "+", "<C-a>" },
		{ "Decrease count", "-", "<C-x>" },
	},
	n = {
		{ "Delete line", "D", "dd" },
		{ "Delete to eol", "dd", "D" },
		{ "Substitute to eol (same as change)", "ss", "C" },
		{ "Yank line", "Y", "yy" },
		{ "Yank to eol", "yy", "y$" },
		{ "Copy down", "yp", "Yp" },
		{ "Undo last jump", { colemak = "<C-u>", qwerty = "<C-i>" }, "<C-o>" },
		{ "Redo last jump", { colemak = "<C-y>", qwerty = "<C-o>" }, "<C-i>" },
		{ "Insert comma at the end", ",,", "mzA,<Esc>`z" },
		{ "Insert semicolon at the end", { colemak = ",h", qwerty = ",m" }, "mzA;<Esc>`z" },
		{ "Insert comma at the end", ",d", "mz$x`z" },
		{ "Move line down", "<C-d>", ":m +<CR>==" },
		{ "Move line up", "<C-f>", ":m -2<CR>==" },
		{ "Join/Merge lines (pretty)", { colemak = "J", qwerty = "M" }, "mzJ`z" },
		{ "Join/Merge lines (raw)", { colemak = "gJ", qwerty = "gM" }, "mzgJ`z" },
	},
	i = {
		{ "Escape to normal mode", { colemak = "<C-e>", qwerty = "<C-k>" }, "<Esc>" },
		{ "Do one normal mode command", { colemak = "<C-l>" }, "<C-o>" },
		{ "Undo", "<C-u>", "<Esc>u" },
		{ "Delete", "<C-x>", "<Del>" },
		{ "Go outside of the brackets", { colemak = "<C-k>", qwerty = "<C-b>" }, "<Esc>va{A" },
		{ "Go outside of parentheses)", { colemak = "<C-h>", qwerty = "<C-j>" }, "<Esc>va(A" },
		{ "<Esc>la,<space>", "<C-w>", "Comma after string" },
		{ "Move line down", "<C-d>", "<Esc>:m+<CR>==gi" },
		{ "Move line up", "<C-f>", "<Esc>:m-2<CR>==gi" },
	},
	v = {
		{ "Escape to normal mode", { colemak = "<C-e>", qwerty = "<C-k>" }, "<Esc>" },
		{ "Yank (keep the position)", "y", "y`>" },
		{
			"Yank to clipboard",
			"<leader>y",
			"<Esc><cmd>'<,'>w !clip.exe<CR><Esc>",
		},
		{ "Paste (keeping the register)", "p", '"_dP' },
		{ "Move line down", "<C-d>", ":m '>+<CR>gv=gv" },
		{ "Move line up", "<C-f>", ":m '<-2<CR>gv=gv" },
		{ "Deindent (keep selection)", "<", "<gv" },
		{ "Indent (keep selection)", ">", ">gv" },
	},
	c = {
		{ "Escape to normal mode", { colemak = "<C-e>", qwerty = "<C-k>" }, "<Esc>" },
	},
})

return keymap
