Keymaps = {}

function Keymaps.remap(table_of_remaps, shared_opts)
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

require(User .. ".nav.pickers")
