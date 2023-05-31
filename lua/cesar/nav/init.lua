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
 {
  "ahmedkhalf/project.nvim",
  dependencies = {
		"nvim-telescope/telescope.nvim",
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
  end,
},
	"nvim-telescope/telescope-file-browser.nvim",
  "nvim-telescope/telescope-smart-history.nvim",
	{
		"nvim-telescope/telescope-frecency.nvim",
		dependencies = { "kkharji/sqlite.lua" },
	},

  -- Utils
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
	{
		"AckslD/nvim-neoclip.lua",
		lazy = false,
		config = true,
	},
}
