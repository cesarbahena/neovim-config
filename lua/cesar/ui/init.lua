local M = {
  { "norcalli/nvim-colorizer.lua", config = true },
}

local plugins = {
  "lualine",
  "noice",
  "devicons",
  "catppuccin",
}

for _, plugin in ipairs(plugins) do
  table.insert(M, require(User .. ".ui." .. plugin))
end

return M
