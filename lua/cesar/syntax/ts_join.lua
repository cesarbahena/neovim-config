return {
	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesj").setup({
				use_default_keymaps = false,
			})
			local keymaps = require(User .. ".config.keymaps")
			keymaps({
				[""] = {
					{ "Toggle split/join", { colemak = "<leader>j", qwerty = "<leader>m" }, require("treesj").toggle },
				},
			})
		end,
	},
}
