return function()
	local keymaps = require(User .. ".config.keymaps")
	local dap = require("dap")
	local dapui = require("dapui")

	keymaps({
		[""] = {
			{ "Continue", "B", dap.continue },
			{ "Step over", ">", dap.step_over },
			{ "Step into", "<", dap.step_into },
			{ "Step out", "be", dap.step_out },
			{ "Debug with last configuration", "bb", dap.run_last },
			{ "Run to Cursor", "bt", dap.run_to_cursor },
			{ "Toggle Breakpoint", "bp", dap.toggle_breakpoint },
			{ "Toggle UI", "<leader>b", dapui.toggle },
			{ "Inspect expresion", "bi", dapui.eval },
			-- This has to be a vim cmd because elements.watches doesn't exist yet
			{ "Watch variable", "bw", [[<cmd>lua require("dapui").elements.watches.add()<CR>]] },
			{
				"Breakpoint condition",
				"by",
				function()
					vim.ui.input({ prompt = "Breakpoint condition:" }, function(condition)
						dap.set_breakpoint(condition)
					end)
				end,
			},
			{
				"Logpoint",
				"bl",
				function()
					vim.ui.input({ prompt = "Log:" }, function(log)
						dap.set_breakpoint(nil, nil, log)
					end)
				end,
			},
			{
				"Terminate debug session",
				"bq",
				function()
					dap.terminate()
					dapui.close()
				end,
			},
		},
	})

	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open({})
	end

	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close({})
	end
end
