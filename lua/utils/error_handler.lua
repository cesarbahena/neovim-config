local get_or_create = require 'utils'.get_or_create

local M = {}

-- Transform an error string to an structured error
-- TODO: Implement more useful errors
function M.split_error_message(msg)
  -- Validate error message
  if type(msg) ~= "string" then return "", {} end

  local first_line = msg:match("([^\n]*)")
  local rest = msg:sub(#first_line + 2)
  local raw_lines = vim.split(rest, "\n", { plain = true, trimempty = true })

  -- Trim tabs and spaces from each line
  local details = vim.tbl_map(vim.trim, raw_lines)

  return vim.trim(first_line), details
end

-- Try class
local Try = {}
Try.__index = Try

function Try.new(fn, ...)
  if type(fn) ~= 'function' then
    error('Wrong use of try(fn, ...): fn must be a function')
  end

  local self = {}
  setmetatable(self, {
    __index = Try,
    __call = function(self, fallback)
      if self.ok then
        return self.value, self.ok
      end

      if type(fallback) == 'function' then
        return fallback(), self.ok
      end

      return fallback, self.ok
    end,
  })

  local args = { ... }
  self.ok = xpcall(
    function() self.value = fn(unpack(args)) end, 
    function(err)
      local first_line, details = M.split_error_message(err)
      local _, traceback = M.split_error_message(debug.traceback("", 2))
      self.error = {
        message = first_line,
        details = details,
        traceback = traceback,
        time = os.date("%Y-%m-%d %H:%M:%S"),
      }
    end
  )
  return self
end

function Try:catch(handler)
  if self.ok then return self end
  if type(handler) == "string" then
    table.insert(get_or_create('Errors.' .. handler), self.error) 
  elseif type(handler) == "function" then
    handler(self.error)
  end
  return self
end

-- Try instance factory
function M.try(fn, ...)
  return Try.new(fn, ...)
end

return M
