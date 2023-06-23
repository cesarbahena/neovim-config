return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-telescope/telescope-ui-select.nvim",
	},
	keys = function()
		local installed, dap = pcall(require, "dap")
		if installed then
			return {
				{ desc = "Continue", "B", dap.continue },
				{ desc = "Step over", ">", dap.step_over },
				{ desc = "Step into", "<", dap.step_into },
				{ desc = "Step out", "be", dap.step_out },
				{ desc = "Debug again", "bb", dap.run_last },
				{ desc = "Run to Cursor", "bt", dap.run_to_cursor },
				{ desc = "Toggle Breakpoint", "bp", dap.toggle_breakpoint },
				{
					desc = "Breakpoint condition",
					"bf",
					function()
						vim.ui.input({ prompt = "Breakpoint condition:" }, function(condition)
							dap.set_breakpoint(condition)
						end)
					end,
				},
				{
					desc = "Logpoint",
					"bl",
					function()
						vim.ui.input({ prompt = "Log:" }, function(log)
							dap.set_breakpoint(nil, nil, log)
						end)
					end,
				},
			}
		end
	end,
	config = function()
		vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "StatuslineError", linehl = "", numhl = "" })
		vim.fn.sign_define("DapStopped", { text = " ", texthl = "StatuslineOk", linehl = "", numhl = "" })
		vim.fn.sign_define(
			"DapBreakpointRejected",
			{ text = " ", texthl = "StatuslineError", linehl = "", numhl = "" }
		)
		vim.fn.sign_define(
			"DapBreakpointCondition",
			{ text = " ", texthl = "StatuslineWarn", linehl = "", numhl = "" }
		)
		vim.fn.sign_define("DapLogPoint", { text = "󱅰 ", texthl = "", linehl = "", numhl = "" })
	end,
}
