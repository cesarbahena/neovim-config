-- Setup global variables and functions
require('globals').setup()

-- Run tests for globals
local globals_test = require('tests.globals')
if not globals_test.print_results() then
  vim.notify("Global tests failed - config may not work properly", vim.log.levels.WARN)
end

require 'config'
