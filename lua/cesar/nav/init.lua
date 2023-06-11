-- local opener
-- if vim.fn.has("wsl") == 1 then
-- 	opener = "wslview"
-- elseif vim.fn.has("macunix") == 1 then
-- 	opener = "open"
-- elseif vim.fn.has("linux") == 1 then
-- 	opener = "xdg-open"
-- elseif vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 then
-- 	opener = "start"
-- end

return {
	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.1",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
			},
		},
		config = require(User .. ".nav.telescope"),
	},

	-- Find files
	require(User .. ".nav.projects"),
	"nvim-telescope/telescope-file-browser.nvim",
	{
		"nvim-telescope/telescope-frecency.nvim",
		dependencies = { "kkharji/sqlite.lua" },
	},

	-- Utils
	require(User .. ".nav.harpoon"),
	require(User .. ".nav.trouble"),
	{
		"AckslD/nvim-neoclip.lua",
		lazy = false,
		opts = {
			keys = {
				telescope = {
					i = {
						paste = false,
						edit = false,
					},
				},
			},
		},
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
	},
	{
		"axieax/urlview.nvim",
		-- opts = {
		-- 	default_action = opener,
		-- },
	},
}
