_G.KeyboardLayout = "colemak"

_G.try = require 'utils.error_handler'.try

local spec_gen = require 'utils.keymap_spec_generator'
_G.normal = spec_gen.normal
_G.visual = spec_gen.visual
_G.pending = spec_gen.pending
_G.insert = spec_gen.insert
_G.command = spec_gen.command
_G.motion = spec_gen.motion
_G.operator = spec_gen.operator
_G.edit = spec_gen.edit

local utils = require 'utils'
_G.fn = utils.fn
_G.cmd = utils.cmd

-- Test try function
local function test_try()
  local success_val, success_ok = try(function() return "success" end):catch('TestError')()
  if not (success_val == "success" and success_ok == true) then
    vim.notify("try success case failed", vim.log.levels.ERROR)
    return false
  end
  
  local error_val, error_ok = try(function() error("test error") end):catch('TestError')("fallback")
  if not (error_val == "fallback" and error_ok == false) then
    vim.notify("try error case failed", vim.log.levels.ERROR)
    return false
  end
  
  return true
end

if not test_try() then
  vim.notify("try function tests failed - config may not work properly", vim.log.levels.WARN)
end

require 'config'
