return {
	"booperlv/nvim-gomove",
	config = function()
		require("gomove").setup({ map_defaults = false })
		local keymaps = require(User .. ".config.keymaps")

		keymaps({
			n = {
				{ "n", "<C-r>", "<Plug>GoNSMLeft" },
				{ "n", "<C-c>", "<Plug>GoNSMDown" },
				{ "n", "<C-s>", "<Plug>GoNSMUp" },
				{ "n", "<C-d>", "<Plug>GoNSMRight" },
				{ "n", "<C-M-r>", "<Plug>GoNSDLeft" },
				{ "n", "<C-M-c>", "<Plug>GoNSDDown" },
				{ "n", "<C-M-s>", "<Plug>GoNSDUp" },
				{ "n", "<C-M-d>", "<Plug>GoNSDRight" },
			},

			x = {
				{ "x", "<C-r>", "<Plug>GoVSMLeft" },
				{ "x", "<C-c>", "<Plug>GoVSMDown" },
				{ "x", "<C-s>", "<Plug>GoVSMUp" },
				{ "x", "<C-d>", "<Plug>GoVSMRight" },
				{ "x", "<C-M-r>", "<Plug>GoVSDLeft" },
				{ "x", "<C-M-c>", "<Plug>GoVSDDown" },
				{ "x", "<C-M-s>", "<Plug>GoVSDUp" },
				{ "x", "<C-M-d>", "<Plug>GoVSDRight" },
			},
		})
	end,
}
