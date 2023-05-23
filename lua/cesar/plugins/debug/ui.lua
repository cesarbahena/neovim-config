return {
	{
		"rcarriga/nvim-dap-ui",
		keys = {
			{
				"<leader>du",
				function()
					require("dapui").toggle({})
				end,
				desc = "Dap UI",
			},
			{
				"<leader>de",
				function()
					require("dapui").eval()
				end,
				desc = "Eval",
				mode = { "n", "v" },
			},
		},
		config = function(_, opts)
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup(opts)
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close({})
			end
		end,
	},
	{
		"nvim-telescope/telescope-dap.nvim",
		keys = {
			{
				"<leader>dm",
				function()
					require("telescope").extensions.dap.commands(require("telescope.themes").get_dropdown())
				end,
				desc = "Find debugger commands",
			},
			{
				"<leader>fdc",
				function()
					require("telescope").extensions.dap.configurations(require("telescope.themes").get_dropdown())
				end,
				desc = "Find debugger configurations",
			},
			{
				"<leader>fb",
				function()
					require("telescope").extensions.dap.list_breakpoints({})
				end,
				desc = "Find breakpoints",
			},
			{
				"<leader>fv",
				function()
					require("telescope").extensions.dap.variables({})
				end,
				desc = "Find variables",
			},
			{
				"<leader>fdf",
				function()
					require("telescope").extensions.dap.frames({})
				end,
				desc = "Find frames",
			},
		},
		config = function()
			require("telescope").load_extension("dap")
		end,
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		config = function()
			require("nvim-dap-virtual-text").setup({
				enabled = true,
				-- DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, DapVirtualTextForceRefresh
				enabled_commands = false,
				-- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
				highlight_changed_variables = true,
				highlight_new_as_changed = true,
				-- prefix virtual text with comment string
				commented = false,
				show_stop_reason = true,
				-- experimental features:
				virt_text_pos = "eol", -- position of virtual text, see `:h nvim_buf_set_extmark()`
			})
		end,
	},
}
