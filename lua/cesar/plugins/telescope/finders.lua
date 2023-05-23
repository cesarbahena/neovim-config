local action_state = require("telescope.actions.state")
local themes = require("telescope.themes")
local map_tele = Keymaps.ymap_telescope
local telescope = Keymaps.map_telescope
local map = Keymaps.remap

local M = {}
map_tele("<space><space>d", "diagnostics")

map_tele("<space>fo", "oldfiles")
map_tele("<space>fe", "file_browser")

map_tele("<space>fgs", "git_status")

map_tele("<space>fb", "buffers")
map_tele("<space>fa", "installed_plugins")
map_tele("<space>fi", "search_all_files")
map_tele("<space>ff", "curbuf")
map_tele("<space>fh", "help_tags")
map_tele("<space>bo", "vim_options")
map_tele("<space>gp", "grep_prompt")
map_tele("<space>wt", "treesitter")

map({
	[""] = {
		{
			"Edit neovim config",
			"<leader>en",
			telescope("fd", "wide", {
				prompt_title = "Find in Neovim config",
				cwd = "~/.config/nvim/lua/" .. User,
				layout_config = {
					width = { padding = 0.2 },
				},
			}),
		},
		{
			"Find files",
			"<leader>fp",
			telescope("fd", "wide"),
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
			"Find builtin",
			"<leader>fB",
			telescope("builtin", "tiny"),
		},
		{
			"Find git files",
			"<leader>fg",
			telescope("git_files", "dropdown"),
		},
		{
			"Find breakpoints",
			"<leader>fl",
			telescope("list_breakpoints", "wide", nil, "dap"),
		},
	},
})

function M.oldfiles()
	require("telescope").extensions.frecency.frecency(themes.get_ivy({}))
end

function M.installed_plugins()
	require("telescope.builtin").find_files({
		cwd = vim.fn.stdpath("data") .. "/lazy/",
	})
end

function M.project_search()
	require("telescope.builtin").find_files({
		previewer = false,
		layout_strategy = "vertical",
		cwd = require("nvim_lsp.util").root_pattern(".git")(vim.fn.expand("%:p")),
	})
end

function M.buffers()
	require("telescope.builtin").buffers({
		shorten_path = false,
	})
end

function M.curbuf()
	local opts = themes.get_dropdown({
		-- winblend = 10,
		border = true,
		previewer = false,
		shorten_path = false,
	})
	require("telescope.builtin").current_buffer_fuzzy_find(opts)
end

function M.help_tags()
	require("telescope.builtin").help_tags({
		show_version = true,
	})
end

function M.search_all_files()
	require("telescope.builtin").find_files({
		find_command = { "rg", "--no-ignore", "--files" },
	})
end

function M.file_browser()
	local opts

	opts = {
		sorting_strategy = "ascending",
		scroll_strategy = "cycle",
		layout_config = {
			prompt_position = "top",
		},

		attach_mappings = function(prompt_bufnr, map)
			local current_picker = action_state.get_current_picker(prompt_bufnr)

			local modify_cwd = function(new_cwd)
				local finder = current_picker.finder

				finder.path = new_cwd
				finder.files = true
				current_picker:refresh(false, { reset_prompt = true })
			end

			map("i", "-", function()
				modify_cwd(current_picker.cwd .. "/..")
			end)

			map("i", "~", function()
				modify_cwd(vim.fn.expand("~"))
			end)

			-- local modify_depth = function(mod)
			--   return function()
			--     opts.depth = opts.depth + mod
			--
			--     current_picker:refresh(false, { reset_prompt = true })
			--   end
			-- end
			--
			-- map("i", "<M-=>", modify_depth(1))
			-- map("i", "<M-+>", modify_depth(-1))

			map("n", "yy", function()
				local entry = action_state.get_selected_entry()

				vim.fn.setreg("+", entry.value)
			end)

			return true
		end,
	}

	require("telescope").extensions.file_browser.file_browser(opts)
end

function M.git_status()
	local opts = themes.get_dropdown({
		border = true,
		previewer = false,

		shorten_path = false,
	})

	-- Can change the git icons using this.
	-- opts.git_icons = {

	--   changed = "M"
	-- }

	require("telescope.builtin").git_status(opts)
end

function M.git_commits()
	require("telescope.builtin").git_commits({})
end

function M.search_only_certain_files()
	require("telescope.builtin").find_files({
		find_command = {
			"rg",
			"--files",
			"--type",
			vim.fn.input("Type: "),
		},
	})
end

function M.lsp_references()
	require("telescope.builtin").lsp_references({
		layout_strategy = "vertical",
		layout_config = {
			prompt_position = "top",
		},
		sorting_strategy = "ascending",
		ignore_filename = false,
	})
end

function M.lsp_implementations()
	require("telescope.builtin").lsp_implementations({
		layout_strategy = "vertical",

		layout_config = {
			prompt_position = "top",
		},

		sorting_strategy = "ascending",
		ignore_filename = false,
	})
end

function M.vim_options()
	require("telescope.builtin").vim_options({
		layout_config = {
			width = 0.5,
		},
		sorting_strategy = "ascending",
	})
end

return M
