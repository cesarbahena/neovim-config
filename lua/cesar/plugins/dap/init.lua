return {
  {
    'mfussenegger/nvim-dap',
    keys = {
      { '<F5>', "<cmd>lua require'dap'.continue()<CR>", desc = 'Continue' },
      { '<F3>', "<cmd>lua require'dap'.step_over()<CR>", desc = 'Step over' },
      { '<F2>', "<cmd>lua require'dap'.step_into()<CR>", desc = 'Step into' },
      { '<F12>', "<cmd>lua require'dap'.step_out()<CR>", desc = 'Step out' },
      { '<leader>b', "<cmd>lua require'dap'.toggle_breakpoint()<CR>", desc = 'Toogle breakpoint' },
      { '<leader>B', "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", desc =  'Breakpoint condition' },
      { '<leader>lp', "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", desc = 'Log point' },
      { '<leader>dr', "<cmd>lua require'dap'.repl.open()<CR>", desc = 'Debug REPL' },
      { '<leader>dt', "<cmd>lua require'dap-go'.debug_test()<CR>", desc = 'Test' },
    },
  },
  { 'rcarriga/nvim-dap-ui', config = true },
  { 'theHamsta/nvim-dap-virtual-text', config = true },
  'nvim-telescope/telescope-dap.nvim',
  {
    "microsoft/vscode-js-debug",
    build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
  },
  {
    'mxsdev/nvim-dap-vscode-js',
    config = function()
      require 'dap-vscode-js'.setup{
        debugger_cmd = { "js-debug-adapter" },
        adapters = { "pwa-node", "pwa-chrome", "node-terminal" },
      }
      Require(User..'.plugins.dap', {
        'javascript'
      }, true)
    end,
  },
}
