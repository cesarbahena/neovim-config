return function()
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local finders = require("telescope.finders")
	local pickers = require("telescope.pickers")
	local conf = require("telescope.config").values

	require("dap.ui").pick_one = function(items, prompt, label_fn, cb)
		local opts = {
			layout_strategy = "bottom_pane",
			layout_config = {
				height = 0.2,
			},
		}
		pickers
			.new(opts, {
				prompt_title = prompt,
				finder = finders.new_table({
					results = items,
					entry_maker = function(entry)
						return {
							value = entry,
							display = label_fn(entry),
							ordinal = label_fn(entry),
						}
					end,
				}),
				sorter = conf.generic_sorter(opts),

				attach_mappings = function(prompt_bufnr)
					actions.select_default:replace(function()
						local selection = action_state.get_selected_entry()
						actions.close(prompt_bufnr)

						cb(selection.value)
					end)

					return true
				end,
			})
			:find()
	end
end
