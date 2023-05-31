-- Wrapper global function for ease of use in mappings
return function (finder, picker, opts, extension)
	local function params(defaults)
		if opts then
			return vim.tbl_deep_extend("force", defaults, opts)
		end
		return defaults
	end

	-- Add pickers here
	local pickers = {
		ivy = require("telescope.themes").get_ivy(params({
			prompt_prefix = "   ",
			sorting_strategy = "ascending",
			layout_config = {
				prompt_position = "top",
			},
		})),

		dropdown = require("telescope.themes").get_dropdown(params({
			sorting_strategy = "ascending",
			previewer = false,
		})),

		tiny = require("telescope.themes").get_dropdown(params({
			sorting_strategy = "ascending",
			previewer = false,
			layout_config = {
				width = { padding = 0.4 },
			},
		})),

		vertical = {
			prompt_prefix = "   ",
			sorting_strategy = "ascending",
			layout_strategy = "vertical",
			layout_config = {
				prompt_position = "top",
				width = 0.9,
				height = 0.95,
				preview_height = 0.5,
			},
		},

		padded = params({
			prompt_prefix = "   ",
			sorting_strategy = "ascending",
			layout_strategy = "horizontal",
			layout_config = {
				prompt_position = "top",
				width = { padding = 0.2 },
				preview_width = 0.6,
			},
		}),

		wide = params({
			prompt_prefix = "   ",
			sorting_strategy = "ascending",
			layout_strategy = "horizontal",
			layout_config = {
				prompt_position = "top",
				width = 0.95,
				height = 0.85,
				preview_width = 0.6,
			},
		}),
	}

	if extension then
		return function()
			require("telescope").extensions[extension][finder](pickers[picker])
		end
	end
	return function()
		require("telescope.builtin")[finder](pickers[picker])
	end
end
