---@diagnostic disable: missing-fields
local test = require('test.framework')
local try_module = require('utils.try')

local describe = test.describe
local it = test.it
local before_each = test.before_each
local assert = test.assert
local assert_equal = test.assert_equal
local assert_deep_equal = test.assert_deep_equal
local assert_nil = test.assert_nil
local assert_not_nil = test.assert_not_nil

local try = try_module.try

describe('Try API - Simple Function Calls', function()
  before_each(function()
    _G.Errors = {}
  end)
  
  it('should execute successful function calls', function()
    local result, success = try(function(x, y) return x + y end, 5, 3)
    assert_equal(result, 8)
    assert_equal(success, true)
  end)
  
  it('should handle function call errors', function()
    local result, success = try(function() error('test error') end)
    assert_nil(result)
    assert_equal(success, false)
    assert_equal(#_G.Errors, 1)
    assert_equal(_G.Errors[1].message, 'test error')
  end)
  
  it('should pass multiple arguments correctly', function()
    local result, success = try(function(a, b, c, d) 
      return string.format('%s-%s-%s-%s', a, b, c, d)
    end, 'hello', 'world', 123, true)
    
    assert_equal(result, 'hello-world-123-true')
    assert_equal(success, true)
  end)
end)

describe('Try API - Single Operations with Options', function()
  before_each(function()
    _G.Errors = {}
  end)
  
  it('should handle successful single operations', function()
    local result, success = try { function(x) return x * 2 end, 10 }
    assert_equal(result, 20)
    assert_equal(success, true)
  end)
  
  it('should handle or_else fallback with value', function()
    local result, success = try { 
      function() error('test error') end, 
      or_else = 'fallback_value' 
    }
    assert_equal(result, 'fallback_value')
    assert_equal(success, false)
  end)
  
  it('should handle or_else fallback with function', function()
    local result, success = try { 
      function() error('test error') end, 
      or_else = function() return 'dynamic_fallback' end 
    }
    assert_equal(result, 'dynamic_fallback')
    assert_equal(success, false)
  end)
  
  it('should handle catch with error storage', function()
    local caught_error = nil
    local result, success = try { 
      function() error('custom error') end,
      catch = function(e) 
        caught_error = e
        e.custom_field = 'modified'
        return e
      end 
    }
    
    assert_nil(result)
    assert_equal(success, false)
    assert_not_nil(caught_error)
    assert_equal(caught_error.message, 'custom error')
    assert_equal(caught_error.custom_field, 'modified')
    assert_equal(#_G.Errors, 1)
  end)
  
  it('should handle catch without error storage', function()
    local result, success = try { 
      function() error('ignored error') end,
      catch = function(e) 
        return nil -- Don't store error
      end 
    }
    
    assert_nil(result)
    assert_equal(success, false)
    assert_equal(#_G.Errors, 0) -- No error stored
  end)
end)

describe('Try API - Function with Multiple Argument Sets', function()
  before_each(function()
    _G.Errors = {}
  end)
  
  it('should execute function with multiple argument sets', function()
    local results, success = try {
      function(x, y) return x + y end,
      { 1, 2 },
      { 10, 20 },
      { 100, 200 }
    }
    
    assert_deep_equal(results, { 3, 30, 300 })
    assert_equal(success, true)
  end)
  
  it('should handle errors with continue mode', function()
    local results, success = try {
      function(x) 
        if x == 'error' then error('test error') end
        return x .. '_success'
      end,
      { 'first' },
      { 'error' },
      { 'third' },
      on_error = 'continue'
    }
    
    assert_equal(results[1], 'first_success')
    assert_nil(results[2])
    assert_equal(results[3], 'third_success')
    assert_equal(success, false)
    assert_equal(#_G.Errors, 1)
  end)
  
  it('should handle errors with stop mode', function()
    local results, success = try {
      function(x) 
        if x == 'stop' then error('stop error') end
        return x .. '_success'
      end,
      { 'first' },
      { 'stop' },
      { 'should_not_execute' },
      on_error = 'stop'
    }
    
    assert_equal(results[1], 'first_success')
    assert_nil(results[2])
    assert_nil(results[3])
    assert_equal(#results, 1) -- Execution stopped
    assert_equal(success, false)
  end)
  
  it('should handle per-argument-set or_else', function()
    local results, success = try {
      function(x) 
        if x == 'fail' then error('failure') end
        return x * 2
      end,
      { 5 },
      { 'fail', or_else = 'replacement' },
      { 7 }
    }
    
    assert_equal(results[1], 10)
    assert_equal(results[2], 'replacement')
    assert_equal(results[3], 14)
    assert_equal(success, false)
  end)
  
  it('should handle per-argument-set catch', function()
    local catch_called = false
    local results, success = try {
      function(x) 
        if x == 'catch_me' then error('caught') end
        return x .. '_ok'
      end,
      { 'normal' },
      { 'catch_me', catch = function(e) 
        catch_called = true
        return nil -- Don't store
      end },
      { 'another' }
    }
    
    assert_equal(results[1], 'normal_ok')
    assert_nil(results[2])
    assert_equal(results[3], 'another_ok')
    assert_equal(success, false)
    assert_equal(catch_called, true)
  end)
  
  it('should not collect results when configured', function()
    local result, success = try {
      function(x) return x * 2 end,
      { 5 },
      { 10 },
      collect_results = false
    }
    
    assert_nil(result)
    assert_equal(success, true)
  end)
  
  it('should handle global or_else fallback', function()
    local result, success = try {
      function() error('always fails') end,
      { 'arg1' },
      { 'arg2' },
      or_else = 'global_fallback'
    }
    
    assert_equal(result, 'global_fallback')
    assert_equal(success, false)
  end)
end)

describe('Try API - Batch Operations', function()
  before_each(function()
    _G.Errors = {}
  end)
  
  it('should execute batch operations successfully', function()
    local results, success = try {
      { function(x) return x * 2 end, 5 },
      { function(x, y) return x + y end, 10, 20 },
      { function() return 'static' end }
    }
    
    assert_deep_equal(results, { 10, 30, 'static' })
    assert_equal(success, true)
  end)
  
  it('should handle batch errors with continue mode', function()
    local results, success = try {
      { function(x) return x * 2 end, 5 },
      { function() error('batch error') end },
      { function(x) return x + 1 end, 7 },
      on_error = 'continue'
    }
    
    assert_equal(results[1], 10)
    assert_nil(results[2])
    assert_equal(results[3], 8)
    assert_equal(success, false)
  end)
  
  it('should handle batch errors with stop mode', function()
    local results, success = try {
      { function(x) return x * 2 end, 5 },
      { function() error('stop error') end },
      { function(x) return x + 1 end, 7 },
      on_error = 'stop'
    }
    
    assert_equal(results[1], 10)
    assert_nil(results[2])
    assert_nil(results[3])
    assert_equal(#results, 1)
    assert_equal(success, false)
  end)
  
  it('should handle any_success mode', function()
    local result, success = try {
      { function() error('first error') end },
      { function() return 'success!' end },
      { function() return 'second success' end },
      mode = 'any_success'
    }
    
    assert_equal(result, 'success!')
    assert_equal(success, true)
  end)
  
  it('should handle per-operation or_else in batch', function()
    local results, success = try {
      { function(x) return x * 2 end, 5 },
      { function() error('op error') end, or_else = 'operation_fallback' },
      { function(x) return x + 1 end, 7 }
    }
    
    assert_equal(results[1], 10)
    assert_equal(results[2], 'operation_fallback')
    assert_equal(results[3], 8)
    assert_equal(success, true) -- All operations have results
  end)
end)

-- Export tests for external execution
return {
  run = function()
    return test.run()
  end
}