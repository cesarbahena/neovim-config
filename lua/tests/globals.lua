-- Test suite for global variables and functions
local M = {}

function M.run_tests()
  local results = {}
  local failed_tests = {}

  -- Test KeyboardLayout
  local function test_keyboard_layout()
    return type(_G.KeyboardLayout) == "string" and _G.KeyboardLayout == "colemak"
  end

  -- Test try function
  local function test_try()
    local success_val, success_ok = try(function() return "success" end):catch('TestError')()
    if not (success_val == "success" and success_ok == true) then
      return false
    end

    local error_val, error_ok = try(function() error("test error") end):catch('TestError')("fallback")
    if not (error_val == "fallback" and error_ok == false) then
      return false
    end

    global 'Errors'.TestError = nil
    return true
  end

  -- Test keymap function
  local function test_keymap()
    return type(_G.keymap) == "function"
  end

  -- Test autocmd function
  local function test_autocmd()
    return type(_G.autocmd) == "function"
  end

  -- Test global function
  local function test_global()
    return type(_G.global) == "function"
  end

  -- Test keymap spec generators
  local function test_keymap_specs()
    local specs = { 'normal', 'visual', 'pending', 'insert', 'command', 'motion', 'operator', 'edit' }
    for _, spec in ipairs(specs) do
      if type(_G[spec]) ~= "function" then
        return false, spec .. " is not a function"
      end
    end
    return true
  end

  -- Test utils functions
  local function test_utils()
    return type(_G.fn) == "function" and type(_G.cmd) == "function"
  end

  -- Run all tests
  local tests = {
    { name = "KeyboardLayout", test = test_keyboard_layout },
    { name = "try", test = test_try },
    { name = "keymap", test = test_keymap },
    { name = "autocmd", test = test_autocmd },
    { name = "global", test = test_global },
    { name = "keymap_specs", test = test_keymap_specs },
    { name = "utils", test = test_utils },
  }

  for _, test_case in ipairs(tests) do
    local success, error_msg = pcall(test_case.test)
    if success and (error_msg == nil or error_msg == true) then
      results[test_case.name] = true
    else
      results[test_case.name] = false
      table.insert(failed_tests, test_case.name .. ": " .. tostring(error_msg or "test failed"))
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
      vim.notify("✗ " .. test_name .. " failed", vim.log.levels.ERROR)
    end
  end

  if #failed_tests > 0 then
    for _, failure in ipairs(failed_tests) do
      vim.notify("  " .. failure, vim.log.levels.ERROR)
    end
  end

  return passed_tests == total_tests
end

return M