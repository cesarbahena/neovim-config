return {
	"nvim-telescope/telescope-project.nvim",
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
							"Toggle project rooter",
							"<leader>tr",
							function()
								if not Multiproject then
									vim.api.nvim_clear_autocmds({ group = "nvim_rooter" })
									Multiproject = true
									vim.notify("Muti project mode")
									return
								end

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
								Multiproject = false
								vim.notify("Single project mode")
							end,
						},
					},
				})
			end,
		},
	},
	config = function()
		-- require("project_nvim").setup({ manual_mode = true })
		require("telescope").load_extension("project")
	end,
}
