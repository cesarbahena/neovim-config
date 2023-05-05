return {
  {
    'mfussenegger/nvim-dap',
    keys = {
      { "<leader>b",  function() require("dap").toggle_breakpoint() end,                                    desc =
      "Toggle Breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
                                                                                                              desc =
        "Breakpoint Condition" },
      { "<leader>dc", function() require("dap").continue() end,                                             desc =
      "Continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end,                                        desc =
      "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end,                                                desc =
      "Go to line (no execute)" },
      { "<leader>di", function() require("dap").step_into() end,                                            desc =
      "Step Into" },
      { "<leader>dn", function() require("dap").down() end,                                                 desc = "Down" },
      { "<leader>de", function() require("dap").up() end,                                                   desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end,                                             desc =
      "Run Last" },
      { "<leader>do", function() require("dap").step_out() end,                                             desc =
      "Step Out" },
      { "<leader>dO", function() require("dap").step_over() end,                                            desc =
      "Step Over" },
      { "<leader>dp", function() require("dap").pause() end,                                                desc =
      "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end,                                          desc =
      "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end,                                              desc =
      "Session" },
      { "<leader>dt", function() require("dap").terminate() end,                                            desc =
      "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end,                                     desc =
      "Widgets" },
    },
    dependencies = {
      {
        'rcarriga/nvim-dap-ui',
        keys = {
          { "<leader>du", function() require("dapui").toggle({}) end,  desc = "Dap UI" },
          { "<leader>de", function() require("dapui").eval() end,      desc = "Eval",  mode = { "n", "v" } },
        },
        opts = {},
        config = function(_, opts)
          local dap = require("dap")
          local dapui = require("dapui")
          dapui.setup(opts)
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open {}
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close {}
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close {}
          end
        end
      },
      { 'theHamsta/nvim-dap-virtual-text', config = true },
      {
        'nvim-telescope/telescope-dap.nvim',
        keys = {
          { "<leader>dm", function() require 'telescope'.extensions.dap.commands(require'telescope.themes'.get_dropdown()) end,       desc =
          "Find debugger commands" },
          { "<leader>fdc", function() require 'telescope'.extensions.dap.configurations(require'telescope.themes'.get_dropdown()) end,
                                                                                                  desc =
            "Find debugger configurations" },
          { "<leader>fb",  function() require 'telescope'.extensions.dap.list_breakpoints {} end,
                                                                                                  desc =
            "Find breakpoints" },
          { "<leader>fv",  function() require 'telescope'extensions.dap.variables {} end,      desc = "Find variables" },
          { "<leader>fdf", function() require 'telescope'.extensions.dap.frames {} end,         desc = "Find frames" },
        },
      },
    },
  },
  {
    'mxsdev/nvim-dap-vscode-js',
    dependencies = {
      "microsoft/vscode-js-debug",
      build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
    },
    opts = {
      debugger_cmd = { "js-debug-adapter" },
      adapters = { "pwa-node", "pwa-chrome", "node-terminal" },
    },
    config = function(_, opts)
      require 'dap-vscode-js'.setup(opts)
      require(User .. '.plugins.dap.javascript')()
    end,
  },
}
