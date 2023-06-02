return function()
	local keymap = require(User .. ".config.mappings")
	local dap = require("dap")
	local dapui = require("dapui")
	local harpoon = require("harpoon.ui")

	keymap({
		[""] = {
			{ "Continue", "B", dap.continue },
			{ "Debug with last configuration", "bb", dap.run_last },
			{ "Run to Cursor", "bt", dap.run_to_cursor },
			{ "Toggle Breakpoint", "bp", dap.toggle_breakpoint },
			{ "Toggle UI", "bu", dapui.toggle },
			{ "Inspect expresion", "bi", dapui.eval },
			{ "Watch variable", "bw", [[<cmd>lua require("dapui").elements.watches.add()<CR>]] },
			{
				"Breakpoint condition",
				"bf",
				function()
					vim.ui.input({ prompt = "Breakpoint condition" }, function(condition)
						dap.set_breakpoint(condition)
					end)
				end,
			},
			{
				"Logpoint",
				"bl",
				function()
					vim.ui.input({ prompt = "Log" }, function(log)
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
		keymap({
			n = {
				{ "Step into", "<C-i>", dap.step_into },
				{ "Step out", "<C-e>", dap.step_out },
				{ "Step over", "<C-n>", dap.step_over },
			},
		})
	end

	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close({})
		keymap({
			n = {
				{
					"Navigate to file 1",
					"<C-n>",
					function()
						harpoon.nav_file(1)
					end,
				},
				{
					"Navigate to file 2",
					"<C-e>",
					function()
						harpoon.nav_file(2)
					end,
				},
				{
					"Navigate to file 3",
					"<C-i>",
					function()
						harpoon.nav_file(3)
					end,
				},
			},
		})
	end

	dap.listeners.before.event_exited["dapui_config"] = function()
		keymap({
			n = {
				{
					"Navigate to file 1",
					"<C-n>",
					function()
						harpoon.nav_file(1)
					end,
				},
				{
					"Navigate to file 2",
					"<C-e>",
					function()
						harpoon.nav_file(2)
					end,
				},
				{
					"Navigate to file 3",
					"<C-i>",
					function()
						harpoon.nav_file(3)
					end,
				},
			},
		})
	end
end
