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

  -- Test try function-with-arg-tables functionality
  local function test_try_function_with_arg_tables()
    -- Clear errors for clean test
    _G.Errors = {}
    
    -- Test 1: Basic function with multiple arg sets
    local results1, ok1 = try {
      function(x, y) return x + y end,
      { 5, 3 },
      { 10, 20 },
      { 1, 2 }
    }
    if not (ok1 == true and results1[1] == 8 and results1[2] == 30 and results1[3] == 3) then
      return false, 'basic function with arg tables test failed'
    end

    -- Test 2: require pattern with actual error
    local results2, ok2 = try {
      function(name) 
        if name == 'bad_module' then error('module not found') end
        return { module = name, loaded = true } 
      end,
      { 'module1' },
      { 'bad_module', catch = function(e) return { message = 'hello, world' } end }
    }
    if not (ok2 == false and results2[1].module == 'module1' and results2[2].message == 'hello, world') then
      return false, 'require pattern test failed'
    end

    -- Test 3: Function with arg tables and errors
    local results3, ok3 = try {
      function(x) 
        if x == 'error' then error('test error') end
        return x .. '_processed'
      end,
      { 'success1' },
      { 'error' },
      { 'success2' }
    }
    if not (ok3 == false and results3[1] == 'success1_processed' and results3[2] == nil and results3[3] == 'success2_processed') then
      return false, 'function with arg tables and errors test failed'
    end

    -- Test 4: Function with per-arg-set or_else
    local results4, ok4 = try {
      function(x) 
        if x == 'fail' then error('intentional error') end
        return x * 2
      end,
      { 5 },
      { 'fail', or_else = 'fallback_value' },
      { 7 }
    }
    if not (ok4 == false and results4[1] == 10 and results4[2] == 'fallback_value' and results4[3] == 14) then
      return false, 'function with per-arg-set or_else test failed'
    end

    -- Test 5: Function with per-arg-set catch
    local catch_called = false
    local results5, ok5 = try {
      function(x) 
        if x == 'catch_me' then error('caught error') end
        return x .. '_ok'
      end,
      { 'normal' },
      { 'catch_me', catch = function(e) 
        catch_called = true
        e.handled_by = 'per_arg_catch'
        return e
      end },
      { 'another' }
    }
    if not (ok5 == false and results5[1] == 'normal_ok' and results5[2] == nil and results5[3] == 'another_ok' and catch_called) then
      return false, 'function with per-arg-set catch test failed'
    end

    -- Test 6: Function with global or_else fallback
    local result6, ok6 = try {
      function(x) error('always fails') end,
      { 'arg1' },
      { 'arg2' },
      or_else = function() return 'global_fallback' end
    }
    if not (ok6 == false and result6 == 'global_fallback') then
      return false, 'function with global or_else fallback test failed'
    end

    -- Test 7: Function without collecting results
    local result7, ok7 = try {
      function(x) return x * 2 end,
      { 5 },
      { 10 },
      collect_results = false
    }
    if not (ok7 == true and result7 == nil) then
      return false, 'function without collecting results test failed'
    end

    -- Test 8: Function with on_error = 'stop'
    local results8, ok8 = try {
      function(x) 
        if x == 'stop_here' then error('stop error') end
        return x .. '_processed'
      end,
      { 'first' },
      { 'stop_here' },
      { 'should_not_execute' }, -- This should not be processed
      on_error = 'stop'
    }
    if not (ok8 == false and results8[1] == 'first_processed' and results8[2] == nil and results8[3] == nil) then
      return false, 'function with on_error stop test failed'
    end

    -- Clear errors after test
    _G.Errors = {}
    return true
  end

  -- Test try batching functionality
  local function test_try_batching()
    -- Clear errors for clean test
    _G.Errors = {}
    
    -- Test 1: Basic sequential batching
    local results1, ok1 = try {
      { function(x) return x * 2 end, 5 },
      { function(x) return x + 10 end, 3 },
      { function(x, y) return x * y end, 4, 6 }
    }
    if not (ok1 == true and results1[1] == 10 and results1[2] == 13 and results1[3] == 24) then
      return false, 'basic batching test failed'
    end

    -- Test 2: Batching with some errors (continue mode)
    local results2, ok2 = try {
      { function(x) return x * 2 end, 5 },
      { function() error('batch error') end },
      { function(x) return x + 1 end, 7 },
      on_error = "continue"
    }
    if not (ok2 == false and results2[1] == 10 and results2[2] == nil and results2[3] == 8) then
      return false, 'batching with errors (continue) test failed'
    end

    -- Test 3: Batching with stop on error
    local results3, ok3 = try {
      { function(x) return x * 2 end, 5 },
      { function() error('stop error') end },
      { function(x) return x + 1 end, 7 }, -- Should not execute
      on_error = "stop"
    }
    if not (ok3 == false and results3[1] == 10 and results3[2] == nil and #results3 == 1) then
      return false, 'batching with stop on error test failed'
    end

    -- Test 4: any_success mode
    local result4, ok4 = try {
      { function() error('first error') end },
      { function() return 'success!' end },
      { function() return 'second success' end }, -- Should not execute
      mode = "any_success"
    }
    if not (ok4 == true and result4 == 'success!') then
      return false, 'any_success mode test failed'
    end

    -- Test 5: Batching with or_else fallback (all fail)
    local result5, ok5 = try {
      { function() error('error 1') end },
      { function() error('error 2') end },
      or_else = function() return 'batch fallback' end
    }
    if not (ok5 == false and result5 == 'batch fallback') then
      return false, 'batching or_else fallback test failed'
    end

    -- Test 6: Batching with catch handler
    local catch_called = false
    local results6, ok6 = try {
      { function(x) return x * 2 end, 5 },
      { function() error('caught error') end },
      catch = function(e, index) 
        catch_called = true
        e.batch_index = index
        return e -- Store the error
      end
    }
    if not (ok6 == false and results6[1] == 10 and catch_called) then
      return false, 'batching with catch handler test failed'
    end

    -- Test 7: Batching without collecting results
    local result7, ok7 = try {
      { function(x) return x * 2 end, 5 },
      { function(x) return x + 10 end, 3 },
      collect_results = false
    }
    if not (ok7 == true and result7 == nil) then
      return false, 'batching without collecting results test failed'
    end

    -- Test 8: Per-operation or_else
    local results8, ok8 = try {
      { function(x) return x * 2 end, 5 },
      { function() error('op error') end, or_else = 'per-op fallback' },
      { function(x) return x + 1 end, 7 }
    }
    if not (ok8 == true and results8[1] == 10 and results8[2] == 'per-op fallback' and results8[3] == 8) then
      return false, 'per-operation or_else test failed'
    end

    -- Test 9: Per-operation catch
    local per_op_catch_called = false
    local results9, ok9 = try {
      { function(x) return x * 2 end, 5 },
      { function() error('per-op error') end, catch = function(e) 
        per_op_catch_called = true
        return nil -- Don't store
      end },
      { function(x) return x + 1 end, 7 }
    }
    if not (ok9 == false and results9[1] == 10 and results9[3] == 8 and per_op_catch_called) then
      return false, 'per-operation catch test failed'
    end

    -- Clear errors after test
    _G.Errors = {}
    return true
  end

  -- Run all tests
  local tests = {
    { name = 'KeyboardLayout', test = test_keyboard_layout },
    { name = 'try', test = test_try },
    { name = 'try_batching', test = test_try_batching },
    { name = 'try_function_with_arg_tables', test = test_try_function_with_arg_tables },
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
