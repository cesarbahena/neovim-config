return function ()
  require("dap").adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
      command = "js-debug-adapter",
      args = { "${port}" },
    },
  }

for _, language in ipairs { "typescript", "javascript" } do
    require("dap").configurations[language] = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
      },
    }
  end

  for _, language in ipairs { "typescriptreact", "javascriptreact" } do
    require("dap").configurations[language] = {
      {
        type = "pwa-chrome",
        name = "Attach - Remote Debugging",
        request = "attach",

        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        port = 9222,
        webRoot = "${workspaceFolder}",
      },
      {

        type = "pwa-chrome",
        name = "Launch Chrome",
        request = "launch",
        url = "http://localhost:3000",
      },
    }
  end
end
