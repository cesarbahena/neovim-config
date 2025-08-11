-- Test batching functionality
require('globals').setup()

print("Testing batching functionality...")

-- Test basic batching
local results1, ok1 = try {
  { function(x) return x * 2 end, 5 },
  { function(x) return x + 10 end, 3 },
  { function(x, y) return x * y end, 4, 6 }
}
print("Basic batching:", vim.inspect(results1), ok1)

-- Test with errors (continue)
local results2, ok2 = try {
  { function(x) return x * 2 end, 5 },
  { function() error('batch error') end },
  { function(x) return x + 1 end, 7 },
  on_error = "continue"
}
print("With errors (continue):", vim.inspect(results2), ok2)

-- Test any_success mode
local result3, ok3 = try {
  { function() error('first error') end },
  { function() return 'success!' end },
  mode = "any_success"
}
print("Any success mode:", result3, ok3)

print("Batching tests completed!")