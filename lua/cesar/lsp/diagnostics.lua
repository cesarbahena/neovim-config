vim.diagnostic.config({
	underline = true,
	virtual_text = false,
	signs = true,

	float = {
		show_header = true,
		border = "rounded",
	},
	severity_sort = true,
	update_in_insert = false,
})

local signs = { Error = " ", Warn = " ", Info = " ", Hint = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local keymaps = require(User .. ".config.keymaps")

keymaps({
	n = {
		{
			"Next diagnostic",
			"]]",
			function()
				vim.diagnostic.goto_next({
					wrap = true,
					float = true,
				})
			end,
		},
		{
			"Previous diagnostic",
			"[[",
			function()
				vim.diagnostic.goto_prev({
					wrap = true,
					float = true,
				})
			end,
		},
		{
			"Diagnostics list",
			"][",
			function()
				vim.diagnostic.open_float({
					scope = "line",
				})
			end,
		},
	},
})
