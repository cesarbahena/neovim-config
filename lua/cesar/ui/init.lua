local M = {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = require(User .. ".ui.lualine"),
	},
	{ "norcalli/nvim-colorizer.lua", config = true },
}

local plugins = {
	"noice",
	"devicons",
	"rosepine",
	"catppuccin",
}

for _, plugin in ipairs(plugins) do
	table.insert(M, require(User .. ".ui." .. plugin))
end

return M
