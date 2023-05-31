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
  "nvim-telescope/telescope-smart-history.nvim",
	{
		"nvim-telescope/telescope-frecency.nvim",
		dependencies = { "kkharji/sqlite.lua" },
	},

  -- Utils
  require(User .. ".nav.harpoon"),
  require(User .. ".nav.trouble"),
	{ "AckslD/nvim-neoclip.lua", config = true, lazy = false },
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
}
