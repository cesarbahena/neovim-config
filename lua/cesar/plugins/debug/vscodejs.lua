return {
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
    require(vim.g.user..'.plugins.debug.config.javascript')()
  end,
}
