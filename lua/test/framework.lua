---@class TestFramework
---A lightweight testing framework for Neovim Lua modules
---Follows standard Lua testing patterns with assertions and descriptive output

local M = {}

---@class TestResult
---@field name string Test name
---@field passed boolean Whether the test passed
---@field message? string Error message if failed
---@field duration number Time taken to run the test in milliseconds

---@class TestSuite
---@field name string Suite name
---@field tests TestResult[] Array of test results
---@field setup? function Setup function called before all tests
---@field teardown? function Teardown function called after all tests

local current_suite = nil
local all_suites = {}

---Create a new test suite
---@param name string Suite name
---@param suite_fn function Function containing test definitions
function M.describe(name, suite_fn)
  local suite = {
    name = name,
    tests = {},
    setup = nil,
    teardown = nil
  }
  
  current_suite = suite
  suite_fn()
  current_suite = nil
  
  table.insert(all_suites, suite)
end

---Define a test within the current suite
---@param name string Test name
---@param test_fn function Test function
function M.it(name, test_fn)
  if not current_suite then
    error('Tests must be defined within a describe() block')
  end
  
  local start_time = vim.uv and vim.uv.hrtime() or 0
  local success, err = pcall(test_fn)
  local end_time = vim.uv and vim.uv.hrtime() or 0
  local duration = (end_time - start_time) / 1000000 -- Convert to milliseconds
  
  local result = {
    name = name,
    passed = success,
    message = success and nil or tostring(err),
    duration = duration
  }
  
  table.insert(current_suite.tests, result)
end

---Set up function for the current suite
---@param setup_fn function Setup function
function M.before_each(setup_fn)
  if not current_suite then
    error('before_each() must be called within a describe() block')
  end
  current_suite.setup = setup_fn
end

---Tear down function for the current suite
---@param teardown_fn function Teardown function
function M.after_each(teardown_fn)
  if not current_suite then
    error('after_each() must be called within a describe() block')
  end
  current_suite.teardown = teardown_fn
end

---Assert that a condition is true
---@param condition any The condition to check
---@param message? string Optional error message
function M.assert(condition, message)
  if not condition then
    error(message or 'Assertion failed: expected truthy value')
  end
end

---Assert that two values are equal
---@param actual any Actual value
---@param expected any Expected value
---@param message? string Optional error message
function M.assert_equal(actual, expected, message)
  if actual ~= expected then
    local default_msg = string.format('Expected %s, got %s', 
      vim.inspect(expected), vim.inspect(actual))
    error(message or default_msg)
  end
end

---Assert that two values are deeply equal (for tables)
---@param actual any Actual value
---@param expected any Expected value
---@param message? string Optional error message
function M.assert_deep_equal(actual, expected, message)
  if not vim.deep_equal(actual, expected) then
    local default_msg = string.format('Expected %s, got %s', 
      vim.inspect(expected), vim.inspect(actual))
    error(message or default_msg)
  end
end

---Assert that a value is nil
---@param value any Value to check
---@param message? string Optional error message
function M.assert_nil(value, message)
  if value ~= nil then
    local default_msg = string.format('Expected nil, got %s', vim.inspect(value))
    error(message or default_msg)
  end
end

---Assert that a value is not nil
---@param value any Value to check
---@param message? string Optional error message
function M.assert_not_nil(value, message)
  if value == nil then
    error(message or 'Expected non-nil value, got nil')
  end
end

---Assert that a function throws an error
---@param fn function Function to test
---@param message? string Optional error message
function M.assert_error(fn, message)
  local success = pcall(fn)
  if success then
    error(message or 'Expected function to throw an error, but it succeeded')
  end
end

---Run all test suites and return results
---@return table results Summary of all test results
function M.run()
  local total_tests = 0
  local passed_tests = 0
  local failed_tests = 0
  local total_duration = 0
  
  print('🧪 Running test suites...\n')
  
  for _, suite in ipairs(all_suites) do
    print(string.format('📋 %s', suite.name))
    
    local suite_passed = 0
    local suite_failed = 0
    local suite_duration = 0
    
    for _, test in ipairs(suite.tests) do
      total_tests = total_tests + 1
      suite_duration = suite_duration + test.duration
      
      if test.passed then
        passed_tests = passed_tests + 1
        suite_passed = suite_passed + 1
        print(string.format('  ✅ %s (%.2fms)', test.name, test.duration))
      else
        failed_tests = failed_tests + 1
        suite_failed = suite_failed + 1
        print(string.format('  ❌ %s (%.2fms)', test.name, test.duration))
        print(string.format('     %s', test.message or 'Unknown error'))
      end
    end
    
    total_duration = total_duration + suite_duration
    print(string.format('  📊 %d passed, %d failed (%.2fms)\n', 
      suite_passed, suite_failed, suite_duration))
  end
  
  -- Print summary
  print('📈 Test Summary')
  print(string.format('  Total: %d tests', total_tests))
  print(string.format('  Passed: %d (%.1f%%)', passed_tests, 
    total_tests > 0 and (passed_tests / total_tests * 100) or 0))
  print(string.format('  Failed: %d (%.1f%%)', failed_tests, 
    total_tests > 0 and (failed_tests / total_tests * 100) or 0))
  print(string.format('  Duration: %.2fms', total_duration))
  
  local success = failed_tests == 0
  print(string.format('\n%s All tests %s!', 
    success and '🎉' or '💥', 
    success and 'passed' or 'failed'))
  
  -- Clear suites for next run
  all_suites = {}
  
  return {
    total = total_tests,
    passed = passed_tests,
    failed = failed_tests,
    duration = total_duration,
    success = success
  }
end

return M