local telescope = require(User .. ".nav.pickers")

Keymap({
	[""] = {
		{
			"Find files",
			"<leader>fp",
			telescope("fd", "wide"),
		},
		{
			"Find git files",
			"<leader>fg",
			telescope("git_files", "dropdown"),
		},
		{
			"Edit neovim config",
			"<leader>en",
			telescope("fd", "padded", {
				prompt_title = "Find in Neovim config",
				cwd = "~/.config/nvim/lua/" .. User,
			}),
		},
		{
			"Find installed plugins",
			"<leader>fip",
			telescope("fd", "padded", {
				prompt_title = "Find installed plugins",
				cwd = vim.fn.stdpath("data") .. "/lazy/",
			}),
		},
		{
			"Live grep",
			"<leader>fl",
			telescope("live_grep", "ivy", {
				previewer = false,
			}),
		},
		{
			"Find word",
			"<leader>fw",
			function()
				require("telescope.builtin").grep_string(require("telescope.themes").get_ivy({
					search = vim.fn.input(":grep "),
					word_match = "-w",
					only_sort_text = true,
					path_display = { "shorten" },
				}))
			end,
		},
		{
			"Find last search",
			"<leader>f/",
			function()
				require("telescope.builtin").grep_string(require("telescope.themes").get_ivy({
					search = vim.fn.getreg("/"):gsub("\\<", ""):gsub("\\>", ""):gsub("\\C", ""),
					word_match = "-w",
					only_sort_text = true,
					path_display = { "shorten" },
				}))
			end,
		},
		{
			"Find buffers",
			"<leader>fb",
			telescope("buffers", "dropdown"),
		},
		{
			"Find current buffer",
			"<leader>ff",
			telescope("current_buffer_fuzzy_find", "dropdown"),
		},
		{
			"Git status",
			"<leader>fgs",
			telescope("git_status", "dropdown", {
				git_icons = {
					-- changed = " ",
				},
			}),
		},
		{
			"Git commit",
			"<leader>fgc",
			telescope("git_commits", "dropdown", {
				git_icons = {
					-- changed = " ",
				},
			}),
		},
		{
			"Find help",
			"<leader>fh",
			telescope("help_tags", "ivy", {}),
		},
		{
			"Find VIM options",
			"<leader>fo",
			telescope("vim_options", "padded", {}),
		},
		{
			"Find builtin",
			"<leader>fB",
			telescope("builtin", "tiny"),
		},
		{
			"Find all files",
			"<leader>fa",
			telescope("fd", "ivy", {
				find_command = { "rg", "--no-ignore", "--files" },
			}),
		},
		{
			"File tree",
			"<leader>ft",
			function()
				require("telescope").extensions.file_browser.file_browser(require("telescope.themes").get_ivy({
          cwd = vim.fn.expand("%:p:h")
				}))
			end,
		},
		{
			"Find projects",
			"<leader>pf",
			telescope("projects", "tiny", nil, "projects"),
		},
		{
			"Frecency",
			"<leader>fr",
			telescope("frecency", "wide", nil, "frecency"),
		},
	},
})
