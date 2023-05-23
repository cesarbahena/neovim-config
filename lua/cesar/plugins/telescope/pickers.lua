-- Wrapper global function for ease of use in mappings
function Keymaps.map_telescope(finder, picker, opts, extension)
	local function params(defaults)
		if opts then
			return vim.tbl_deep_extend("force", defaults, opts)
		end
		return defaults
	end

	-- Add pickers here
	local pickers = {
		ivy = require("telescope.themes").get_ivy(params({
			layout_config = {
				prompt_position = "top",
			},
		})),

		dropdown = require("telescope.themes").get_dropdown(params({
			previewer = false,
		})),

		tiny = require("telescope.themes").get_dropdown(params({
			previewer = false,
			layout_config = {
				width = { padding = 0.4 },
			},
		})),

		vertical = {
			layout_strategy = "vertical",
			layout_config = {
				prompt_position = "top",
				width = 0.9,
				height = 0.95,
				preview_height = 0.5,
			},
		},

		padded = params({
			layout_config = {
				prompt_position = "top",
				width = { padding = 0.2 },
			},
		}),

		wide = params({
			layout_strategy = "horizontal",
			layout_config = {
				prompt_position = "top",
				width = 0.95,
				height = 0.85,
				preview_width = function(_, cols, _)
					if cols > 200 then
						return math.floor(cols * 0.4)
					end
					return math.floor(cols * 0.6)
				end,
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
