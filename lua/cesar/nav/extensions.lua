local M = {}
local extensions = {
	file_browser = {
		"nvim-telescope/telescope-file-browser.nvim",
		keys = function()
			local ok, telescope = pcall(require, User .. ".nav.pickers")
			if ok then
				return {
					{
						desc = "File tree",
						"<leader>ft",
						function()
							require("telescope").extensions.file_browser.file_browser(
								require("telescope.themes").get_ivy({
									cwd = vim.fn.expand("%:p:h"),
								})
							)
						end,
					},
				}
			end
		end,
		opts = function()
			local ok, telescope = pcall(require, "telescope")
			if not ok then
				return
			end

			local file_browser = telescope.extensions.file_browser
			if file_browser.actions then
				return {
					theme = "ivy",
					hijack_netrw = true,
					hidden = true,
					mappings = {
						["i"] = {
							["<C-c>"] = file_browser.actions.create_from_prompt,
							["<C-d>"] = file_browser.actions.remove,
							["<C-r>"] = file_browser.actions.rename,
							["<C-t>"] = file_browser.actions.move,
							["<C-p>"] = file_browser.actions.copy,
							["<C-h>"] = file_browser.actions.goto_home_dir,
						},
					},
				}
			end
		end,
	},

	project = {
		"nvim-telescope/telescope-project.nvim",
		keys = function()
			local ok, telescope = pcall(require, User .. ".nav.pickers")
			if ok then
				return {
					{
						desc = "Find projects",
						"<leader>fa",
						telescope("project", "tiny", nil, "project"),
					},
				}
			end
		end,
		opts = {
			base_dirs = {
				"~/Projects",
			},
		},
	},

	frecency = {
		"nvim-telescope/telescope-frecency.nvim",
		dependencies = { "kkharji/sqlite.lua" },
		keys = function()
			local ok, telescope = pcall(require, User .. ".nav.pickers")
			if ok then
				return {
					{
						desc = "Frecency",
						"<leader>fr",
						telescope("frecency", "wide", nil, "frecency"),
					},
				}
			end
		end,
	},

	["ui-select"] = {
		"nvim-telescope/telescope-ui-select.nvim",
		lazy = true,
		opts = function()
			local ok, themes = pcall(require, "telescope.themes")
			if ok then
				return {
					themes.get_dropdown(),
				}
			end
		end,
	},
}

for name, spec in pairs(extensions) do
	spec.dependencies = spec.dependencies or {}
	table.insert(spec.dependencies, { "nvim-telescope/telescope.nvim" })
	spec.config = function(_, opts)
		local ok, telescope = pcall(require, "telescope")
		if ok then
			telescope.setup({
				extensions = {
					[name] = opts,
				},
			})
			telescope.load_extension(name)
		end
	end
	table.insert(M, spec)
end

return M
