local M = {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = require(User .. ".ui.lualine"),
	},
	{
		"j-hui/fidget.nvim",
		tag = "legacy",
		opts = {
			window = {
				blend = 0,
			},
		},
	},
}

local plugins = {
	"rosepine",
	"catppuccin",
	"devicons",
	"notify",
	"dressing",
	"noice",
}

for _, plugin in ipairs(plugins) do
	table.insert(M, require(User .. ".ui." .. plugin))
end

return M
