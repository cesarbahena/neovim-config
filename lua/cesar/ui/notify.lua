return {
  "rcarriga/nvim-notify",
  dependencies = { "nvim-lua/plenary.nvim" },
  lazy = false,
  config = function()
    require("notify").setup({
      background_colour = "#000000",
    })
    local keymaps = require(User .. ".config.keymaps")
    keymaps({
      [""] = {
        { "Dismiss", "<leader>n", require("notify").dismiss },
      },
    })
    -- })
    -- local log = require("plenary.log").new({
    -- 	plugin = "notify",
    -- 	level = "debug",
    -- 	use_console = false,
    -- })
    -- vim.notify = function(msg, level)
    -- 	log.info(msg, level)
    -- 	if string.find(msg, "method .* is not supported") then
    -- 		return
    -- 	end
    -- 	require("notify")(msg, level)
    -- end
  end,
}
