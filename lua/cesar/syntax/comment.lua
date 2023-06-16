return {
	"numToStr/Comment.nvim",
	config = function()
		require("Comment").setup({
			toggler = {
				line = "C",
				block = "gC",
			},
			opleader = {
				line = "c",
				block = "gc",
			},
			extra = {
				above = "cL",
				below = "cl",
				eol = "cc",
			},
			mappings = {
				basic = true,
				extra = true,
			},
		})
	end,
}
