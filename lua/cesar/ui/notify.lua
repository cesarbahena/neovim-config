return {
	"rcarriga/nvim-notify",
	keys = {
		{ "<leader>fn", "<cmd>Telescope notify<CR>", desc = "Notifications" },
	},
	lazy = false,
	config = function()
		require("notify").setup({
			background_colour = "#000000",
		})
		require("telescope").load_extension("notify")
		local log = require("plenary.log").new({
			plugin = "notify",
			level = "debug",
			use_console = false,
		})
		vim.notify = function(msg, level, opts)
			log.info(msg, level, opts)
			if string.find(msg, "method .* is not supported") then
				return
			end
			require("notify")(msg, level, opts)
		end
	end,
	-- cond = function()
	--   if not pcall(require, "plenary") then
	--     return false
	--   end
	-- if pcall(require, "noice") then
	--   return false
	-- end
	-- return true
	-- end,
}
