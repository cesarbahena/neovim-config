return {
	"ahmedkhalf/project.nvim",
	dependencies = {
		{
			"notjedi/nvim-rooter.lua",
			config = function()
				require("nvim-rooter").setup({
					exclude_filetypes = { "harpoon" },
				})

				require(User .. ".config.keymaps")({
					[""] = {
						{
							"Deactivate rooter (for multiproject)",
							"<leader>tm",
							function()
								vim.api.nvim_clear_autocmds({ group = "nvim_rooter" })
								vim.notify("Muti project mode")
							end,
						},
						{
							"Activate project auto rooter",
							"<leader>ts",
							function()
								local group_id = vim.api.nvim_create_augroup("nvim_rooter", { clear = true })
								local au = vim.api.nvim_create_autocmd

								au("BufRead", {
									group = group_id,
									callback = function()
										vim.api.nvim_buf_set_var(0, "root_dir", nil)
									end,
								})

								au("BufEnter", {
									group = group_id,
									nested = true,
									callback = function()
										require("nvim-rooter").rooter()
									end,
								})

								require("nvim-rooter").rooter()
								vim.notify("Single project mode")
							end,
						},
					},
				})
			end,
		},
	},
	config = function()
		require("project_nvim").setup({ manual_mode = true })
		require("telescope").load_extension("projects")
	end,
}
