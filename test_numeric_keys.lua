-- Test script to verify numeric key generation
_G.KeyboardLayout = 'colemak' -- Set the global needed by keymap_spec_generator
local spec_gen = require('utils.keymap_spec_generator')

print("=== Testing Numeric Key Generation ===")

-- Test basic digit mappings
local basic_keys = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}
for _, digit in ipairs(basic_keys) do
  local key = spec_gen.get_key(digit)
  print(string.format("Digit '%s' -> %s", digit, key or "NOT FOUND"))
end

print("\n=== Testing Tens Combinations ===")

-- Test tens combinations
local tens_combos = {"11", "12", "13", "21", "22", "23", "31", "32", "33"}
for _, combo in ipairs(tens_combos) do
  local key = spec_gen.get_key(combo)
  print(string.format("Combo '%s' -> %s", combo, key or "NOT FOUND"))
end

print("\n=== Testing Double Tens ===")

-- Test double tens
local double_tens = {"111", "112", "113", "221", "222", "223"}
for _, combo in ipairs(double_tens) do
  local key = spec_gen.get_key(combo)
  print(string.format("Double '%s' -> %s", combo, key or "NOT FOUND"))
end

print("\n=== Testing Motion Function ===")

-- Test creating a motion spec
local success, result = pcall(function()
  return motion { "12", function() print("Motion 12 triggered!") end }
end)

if success then
  print("Motion spec created successfully:")
  print(vim.inspect(result))
else
  print("Error creating motion spec:", result)
end