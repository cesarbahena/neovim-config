local M = {}

local modules = {
  "config",
  "nls", -- Non-language servers
  "utils",
}

for _, module in ipairs(modules) do
  table.insert(M, require(User .. ".lsp." .. module))
end

return M
