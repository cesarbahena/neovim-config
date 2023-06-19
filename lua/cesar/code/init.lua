local M = {}

local modules = {
	"treesitter",
	"textobjs",
	"autopairs",
	"toggle",
	"move",
}

for _, module in pairs(modules) do
	table.insert(M, require(User .. ".code." .. module))
end

return M
