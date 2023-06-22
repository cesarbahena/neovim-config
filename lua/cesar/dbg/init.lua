local M = {}
local modules = {
  "dap",
  "dapui",
  "virtext",
  "vscodejs",
}

for _, module in ipairs(modules) do
  table.insert(M, require(User .. ".dbg." .. module))
end

return M
