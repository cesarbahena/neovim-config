local M = {}

-- Enhanced error message parsing
function M.split_error_message(msg)
  if type(msg) ~= 'string' then return '', {} end

  local first_line = msg:match '([^\n]*)'
  local rest = msg:sub(#first_line + 2)
  local raw_lines = vim.split(rest, '\n', { plain = true, trimempty = true })

  -- Clean and filter traceback lines
  local details = {}
  for _, line in ipairs(raw_lines) do
    local cleaned = vim.trim(line)
    -- Skip internal lua/nvim lines and keep user code
    if cleaned ~= '' and not cleaned:match('^%s*%[C%]') and not cleaned:match('vim/_editor%.lua') then
      table.insert(details, cleaned)
    end
  end

  return vim.trim(first_line), details
end

-- Clean error message by removing redundant file path
function M.clean_error_message(msg)
  -- Handle nested error messages - get the actual error after the last file path
  -- Pattern: "file1.lua:0: file2.lua:123: actual error" -> "actual error"
  local cleaned = msg:match('^.*%.lua:%d+: (.+)$') or msg
  return cleaned
end

-- Format traceback for better readability
function M.format_traceback(traceback_lines)
  local formatted = {}
  local step = 1
  local last_location = nil
  
  for _, line in ipairs(traceback_lines) do
    -- Skip header line
    if line:match('^stack traceback:') then
      goto continue
    end
    
    -- Extract file path and line number
    local file, line_num, func_info = line:match('([^:]+):(%d+): ?(.*)$')
    
    if file and line_num then
      -- Get just the filename, not full path
      local filename = file:match('([^/]+)$') or file
      local location = filename .. ':' .. line_num
      
      -- Skip error_handler internal calls and duplicate consecutive locations
      if filename:match('error_handler%.lua') or location == last_location then
        goto continue
      end
      
      -- Clean up function information
      local context = func_info and func_info ~= '' and func_info or 'main chunk'
      -- Remove various noise patterns
      context = context:gsub('^in ', '')
      context = context:gsub('^function ', '')
      context = context:gsub("^'(.+)'$", '%1')  -- Remove quotes around function names
      context = context:gsub('^<.+>$', 'anonymous function')  -- Clean up <path> patterns
      
      table.insert(formatted, string.format(
        '%d. %s → %s',
        step, location, context
      ))
      step = step + 1
      last_location = location
    end
    
    ::continue::
  end
  
  return formatted
end

-- Try class
local Try = {}
Try.__index = Try

function Try.new(fn, ...)
  if type(fn) ~= 'function' then error 'Wrong use of try(fn, ...): fn must be a function' end

  local self = {}
  setmetatable(self, {
    __index = Try,
    __call = function(self, fallback)
      if self.ok then return self.value, self.ok end

      if type(fallback) == 'function' then return fallback(), self.ok end

      return fallback, self.ok
    end,
  })

  local args = { ... }
  self.ok = xpcall(function() self.value = fn(unpack(args)) end, function(err)
    local first_line, details = M.split_error_message(err)
    local full_traceback = debug.traceback('', 2)
    local _, raw_traceback = M.split_error_message(full_traceback)
    
    -- Extract source info from original error message (before cleaning)
    local source_info = M.extract_source_info(full_traceback, fn, first_line)
    local category = M.categorize_error(first_line, source_info)
    
    -- Format traceback for better readability
    local formatted_traceback = M.format_traceback(raw_traceback)
    
    self.error = {
      message = M.clean_error_message(first_line),
      details = details,
      traceback = formatted_traceback,
      module = source_info.module,
      line = source_info.line,
      category = category,
      time = os.date '%Y-%m-%d %H:%M:%S',
    }
  end)
  return self
end

function Try:catch(handler)
  if self.ok then return self end
  if type(handler) == 'string' then
    table.insert(global('Errors.' .. handler), self.error)
  elseif type(handler) == 'function' then
    handler(self.error)
  end
  return self
end

-- Extract source information from traceback and error message
function M.extract_source_info(traceback, fn, error_message)
  -- Handle nested error messages like "vim/loader.lua:0: /path/file.lua:123: actual error"
  -- Look for the LAST .lua file path in the message (the actual source)
  local all_matches = {}
  for match in error_message:gmatch('([^%s:]+%.lua:%d+)') do
    table.insert(all_matches, match)
  end
  
  -- Use the last match (most specific/actual source)
  if #all_matches > 0 then
    local full_path_match = all_matches[#all_matches]
    local filename = full_path_match:match('([^/]+)%.lua:(%d+)')
    if filename then
      local module = filename or 'unknown'
      local line = full_path_match:match(':(%d+)') or 'unknown'
      return {
        module = module,
        line = line
      }
    end
  end
  
  -- Fallback: Get the first user code line from traceback
  local source_line = traceback:match('([^/\n]*%.lua):(%d+)') or 'unknown'
  local module = source_line:match('([^/]+)') or 'unknown'
  local line = source_line:match(':(%d+)') or 'unknown'
  
  -- For require calls, try to get the module being required
  if fn == require then
    local required_module = traceback:match("module '([^']+)' not found")
    if required_module then
      module = required_module:match('([^%.]+)$') or required_module
    end
  end
  
  return {
    module = module,
    line = line
  }
end

-- Categorize errors for better organization
function M.categorize_error(message, source_info)
  if message:match('module.*not found') then
    return 'module_missing'
  elseif message:match('attempt to call') then
    return 'function_error'
  elseif message:match('attempt to index') then
    return 'nil_access'
  elseif message:match('syntax error') or 
         message:match('expected.*near') or
         message:match('unexpected symbol') or
         message:match('<eof> expected') or
         message:match("'end' expected") then
    return 'syntax_error'
  elseif source_info.module:match('lsp') then
    return 'lsp_error'
  elseif source_info.module:match('plugin') then
    return 'plugin_error'
  else
    return 'general_error'
  end
end

-- Try instance factory
function M.try(fn, ...) return Try.new(fn, ...) end

return M
