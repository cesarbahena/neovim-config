return {
	"rcarriga/nvim-dap-ui",
	dependecies = {
		"mfussenegger/nvim-dap",
	},
	keys = function()
		local dap_installed, dap = pcall(require, "dap")
		if not dap_installed then
			return
		end

		local installed, dapui = pcall(require, "dapui")
		if installed then
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end

			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close({})
			end

			return {
				{ desc = "Toggle UI", "<leader>b", dapui.toggle },
				{ desc = "Inspect expresion", "bi", dapui.eval },
				{
					desc = "Watch variable",
					"bw",
					-- This has to be a vim cmd because elements.watches doesn't exist at load time
					[[<cmd>lua require("dapui").elements.watches.add()<CR>]],
				},
			}
		end
	end,
	opts = {
		mappings = {
			edit = "i",
		},
		expand_lines = true,
		layouts = {
			{
				elements = {
					"scopes",
					"stacks",
				},
				size = 40,
				position = "right",
			},
			{
				elements = {
					"repl",
					"watches",
					"breakpoints",
				},
				size = 0.25,
				position = "bottom",
			},
		},
		floating = {
			border = "rounded",
			mappings = {
				close = { "q", "<C-e>" },
			},
		},
	},
}
