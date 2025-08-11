-- Test suite for global variables and functions
local M = {}

function M.run_tests()
  local results = {}
  local failed_tests = {}

  -- Test KeyboardLayout
  local function test_keyboard_layout() return type(_G.KeyboardLayout) == 'string' and _G.KeyboardLayout == 'colemak' end

  -- Test try function
  local function test_try()
    -- Clear errors for clean test
    _G.Errors = {}
    
    -- Test 1: Basic function call with success
    local success_val, success_ok = try(function() return 'success' end)
    if not (success_val == 'success' and success_ok == true) then 
      return false, 'basic success test failed' 
    end

    -- Test 2: Basic function call with error
    local nil_val, error_ok = try(function() error 'test error' end)
    if not (nil_val == nil and error_ok == false) then 
      return false, 'basic error test failed' 
    end

    -- Test 3: Function with arguments
    local math_result, math_ok = try(function(x, y) return x * y end, 6, 7)
    if not (math_result == 42 and math_ok == true) then 
      return false, 'function with args test failed' 
    end

    -- Test 4: Table syntax with or_else fallback
    local fallback_val, fallback_ok = try { function() error 'test error' end, or_else = 'fallback' }
    if not (fallback_val == 'fallback' and fallback_ok == false) then 
      return false, 'or_else fallback test failed' 
    end

    -- Test 5: Table syntax with or_else function
    local func_fallback, func_ok = try { 
      function() error 'test error' end, 
      or_else = function() return 'dynamic fallback' end 
    }
    if not (func_fallback == 'dynamic fallback' and func_ok == false) then 
      return false, 'or_else function test failed' 
    end

    -- Test 6: Table syntax with multiple arguments
    local multi_args, multi_ok = try { function(a, b, c) return a + b + c end, 10, 20, 30 }
    if not (multi_args == 60 and multi_ok == true) then 
      return false, 'multiple args test failed' 
    end

    -- Test 7: Table syntax with catch handler that stores error
    local catch_stored, catch_ok = try { 
      function() error 'custom error' end, 
      catch = function(e) 
        e.custom_field = 'modified'
        return e -- Return to store the error
      end 
    }
    if not (catch_stored == nil and catch_ok == false) then 
      return false, 'catch handler test failed' 
    end

    -- Test 8: Table syntax with catch handler that doesn't store error
    local initial_error_count = #_G.Errors
    local catch_no_store, catch_no_ok = try { 
      function() error 'ignored error' end, 
      catch = function(e) 
        -- Don't return anything to avoid storing
        return nil 
      end 
    }
    if not (catch_no_store == nil and catch_no_ok == false and #_G.Errors == initial_error_count) then 
      return false, 'catch no-store test failed' 
    end

    -- Test 9: Complex case with catch and or_else
    local complex_result, complex_ok = try { 
      function() error 'complex error' end, 
      catch = function(e) 
        e.handled = true
        return e -- Store the error
      end,
      or_else = function() return 'complex fallback' end
    }
    if not (complex_result == 'complex fallback' and complex_ok == false) then 
      return false, 'complex catch+or_else test failed' 
    end

    -- Verify errors were stored appropriately
    if #_G.Errors < 3 then -- Should have at least basic error, catch stored, and complex error
      return false, 'error storage test failed' 
    end

    -- Clear errors after test
    _G.Errors = {}
    return true
  end

  -- Test keymap function
  local function test_keymap() return type(_G.keymap) == 'function' end

  -- Test autocmd function
  local function test_autocmd() return type(_G.autocmd) == 'function' end

  -- Test global function
  local function test_global() return type(_G.global) == 'function' end

  -- Test keymap spec generators
  local function test_keymap_specs()
    local specs = { 'normal', 'visual', 'pending', 'insert', 'command', 'motion', 'operator', 'edit' }
    for _, spec in ipairs(specs) do
      if type(_G[spec]) ~= 'function' then return false, spec .. ' is not a function' end
    end
    return true
  end

  -- Test utils functions
  local function test_utils() return type(_G.fn) == 'function' and type(_G.cmd) == 'function' end

  -- Run all tests
  local tests = {
    { name = 'KeyboardLayout', test = test_keyboard_layout },
    { name = 'try', test = test_try },
    { name = 'keymap', test = test_keymap },
    { name = 'autocmd', test = test_autocmd },
    { name = 'global', test = test_global },
    { name = 'keymap_specs', test = test_keymap_specs },
    { name = 'utils', test = test_utils },
  }

  for _, test_case in ipairs(tests) do
    local success, error_msg = pcall(test_case.test)
    if success and (error_msg == nil or error_msg == true) then
      results[test_case.name] = true
    else
      results[test_case.name] = false
      table.insert(failed_tests, test_case.name .. ': ' .. tostring(error_msg or 'test failed'))
    end
  end

  return results, failed_tests
end

function M.print_results()
  local results, failed_tests = M.run_tests()
  local total_tests = 0
  local passed_tests = 0

  for test_name, passed in pairs(results) do
    total_tests = total_tests + 1
    if passed then
      passed_tests = passed_tests + 1
    else
      vim.notify('✗ ' .. test_name .. ' failed', vim.log.levels.ERROR)
    end
  end

  if #failed_tests > 0 then
    for _, failure in ipairs(failed_tests) do
      vim.notify('  ' .. failure, vim.log.levels.ERROR)
    end
  end

  return passed_tests == total_tests
end

return M
