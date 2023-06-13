return {
	{
		"echasnovski/mini.ai",
		config = function()
			local mini = require("mini.ai")
			local ts = mini.gen_spec.treesitter

			mini.setup({
				custom_textobjects = {
					k = { { "%b()", "%b[]", "%b{}" }, "^.().*().$" },
					d = ts({ a = "@function.outer", i = "@function.inner" }),
					o = ts({ a = "@loop.outer", i = "@loop.inner" }),
					y = ts({ a = "@conditional.outer", i = "@conditional.inner" }),
					b = ts({ a = "@block.outer", i = "@block.inner" }),
					N = ts({ a = "@number.inner", i = "@number.inner" }),
					["/"] = ts({ a = "@regex.outer", i = "@regex.inner" }),
					["="] = ts({ a = "@assignment.outer", i = "@assignment.inner" }),
				},
			})
		end,
	},
}
