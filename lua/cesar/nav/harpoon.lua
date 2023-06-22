return {
	{
		"theprimeagen/harpoon",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = function(self)
			if not pcall(require, self.name) then
				return
			end
			local ui = require("harpoon.ui")
			local custom_add_mark = require(User .. ".nav.add_mark")

			local nmap = {
				{ desc = "Mark file", "<leader>aa", custom_add_mark },
				{ desc = "Toggle Harpoon menu", "<leader>am", ui.toggle_quick_menu },
			}

			local nkeys = { "n", "e", "i", "o" }
			for i, key in ipairs(nkeys) do
				table.insert(nmap, {
					desc = string.format("Navigate to file %d", i),
					string.format("<C-%s>", key),
					function()
						ui.nav_file(i)
					end,
				})
			end

			for i, key in ipairs(nkeys) do
				table.insert(nmap, {
					desc = string.format("Mark as file %d", i),
					string.format("<leader>a%s", key),
					function()
						custom_add_mark(i)
					end,
				})
			end

			return nmap
		end,

		config = function()
			local ui = require("harpoon.ui")
			local mark = require("harpoon.mark")
			local keymaps = require(User .. ".config.keymaps")
			local autocmd = require(User .. ".config.autocmd")

			autocmd({
				"FileType",
				"HarpoonQuickMenu",
				pattern = "harpoon",
				function()
					local menu_map = {
						{ "Disabled", "<C-n>", "<nop>" },
						{ "Close", "<C-e>", ui.toggle_quick_menu },
						{ "Disabled", "<C-i>", "<nop>" },
						{ "Disabled", "<C-o>", "<nop>" },
						{
							"Clear all marks",
							"<leader>ad",
							function()
								mark.clear_all()
								ui.toggle_quick_menu()
								ui.toggle_quick_menu()
							end,
						},
					}

					for i = 1, 9 do
						table.insert(menu_map, {
							string.format("Navigate to file %d", i),
							string.format("%d", i),
							function()
								ui.nav_file(i)
							end,
						})
					end

					keymaps({ n = menu_map }, { buffer = true })
				end,
			})
		end,
	},
}
