return {
	"rcarriga/nvim-notify",
	dependencies = { "nvim-telescope/telescope.nvim" },
	config = function()
		require("notify").setup({ background_colour = "#000000" })
		require("telescope").load_extension("notify")

		require(User .. ".config.keymaps")({
			[""] = {
				{ "Dismiss", "<leader>n", require("notify").dismiss },
			},
		})
	end,
}
