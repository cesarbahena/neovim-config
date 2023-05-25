return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.1",
		lazy = false,
		dependencies = { "nvim-lua/plenary.nvim" },
		config = Plugin("telescope.setup"),
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
		config = function()
			require("telescope").load_extension("fzf")
		end,
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		config = function()
			require("telescope").load_extension("file_browser")
		end,
	},
	{
		"ahmedkhalf/project.nvim",
		dependencies = {
			{
				"notjedi/nvim-rooter.lua",
				config = function()
					require("nvim-rooter").setup({
						exclude_filetypes = { "harpoon" },
					})
				end,
			},
		},
		config = function()
			require("project_nvim").setup({
				manual_mode = true,
			})
			require("telescope").load_extension("projects")
		end,
	},
	{
		"nvim-telescope/telescope-frecency.nvim",
		config = function()
			require("telescope").load_extension("frecency")
		end,
		dependencies = { "kkharji/sqlite.lua" },
	},
}
