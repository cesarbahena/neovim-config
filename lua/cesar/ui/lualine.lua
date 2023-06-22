local sections = {
	lualine_a = {},
	lualine_b = {},
	lualine_c = {},
	lualine_x = {},
	lualine_y = {},
	lualine_z = {},
}

local opts = {
	options = {
		component_separators = "",
		section_separators = "",
		disabled_filetypes = {
			winbar = { "dap-repl" },
		},
	},
	sections = vim.deepcopy(sections),
	inactive_sections = vim.deepcopy(sections),
	winbar = vim.deepcopy(sections),
	inactive_winbar = vim.deepcopy(sections),
}

local function component(type, section, module, name, n)
	if n == nil then
		table.insert(opts[type]["lualine_" .. section], require(User .. ".ui." .. module)[name])
		return
	end

	for i = 1, n do
		table.insert(opts[type]["lualine_" .. section], require(User .. ".ui." .. module)[name .. "_" .. i])
	end
end

return {
	"nvim-lualine/lualine.nvim",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = function()
		component("sections", "c", "file_info", "cwd")
		component("sections", "c", "file_info", "git")
		component("sections", "c", "file_info", "diff")
		component("sections", "x", "server_info", "non_lsp", 3)
		component("sections", "x", "server_info", "lsp", 5)
		component("sections", "x", "server_info", "no_lsp")
		component("winbar", "c", "file_info", "filetype")
		component("winbar", "c", "file_info", "filename")
		component("winbar", "c", "file_info", "diagnostics")
		component("winbar", "c", "file_info", "unsaved")
		component("inactive_winbar", "c", "file_info", "filetype")
		component("inactive_winbar", "c", "file_info", "filename")
		component("inactive_winbar", "c", "file_info", "diagnostics")
		component("inactive_winbar", "c", "file_info", "unsaved")
		return opts
	end,
}
