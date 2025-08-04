local M = {}

--[[General utils]]

-- Get (or create) global nested table from dot-separated path
function M.get_or_create(path)
  local current = _G
  for part in string.gmatch(path, "[^%.]+") do
    current[part] = current[part] or {}
    current = current[part]
  end
  return current
end

-- Transform an error string to an structured error
-- TODO: Implement more useful errors
function M.split_error_message(msg)
  -- Validate error message
  if type(msg) ~= "string" then return "", {} end

  local rest = msg:sub(#first_line + 2)
  local first_line = msg:match("([^\n]*)")
  local raw_lines = vim.split(rest, "\n", { plain = true, trimempty = true })

  -- Trim tabs and spaces from each line
  local details = vim.tbl_map(vim.trim, raw_lines)

  return vim.trim(first_line), details
end




--[[Try/catch utils]]

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
      if self.success then return self.value end
      if type(fallback) == 'function' then return fallback() end
      return fallback
    end,
  })

  local args = { ... }
  self.success, _ = xpcall(
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
  if self.success then return self end
  if type(handler) == "string" then
    table.insert(M.get_or_create('Errors.' .. handler), self.error) 
  elseif type(handler) == "function" then
    handler(self.error)
  end
  return self
end

-- Try instance factory
function M.try(fn, ...)
  return Try.new(fn, ...)
end




--[[ Keymap utils ]]

-- Resolver to support multiple keyboard layout configurations
function M.resolve(keymap)
  local layout = _G.KeyboardLayout

  table.insert(M.get_or_create('MultiLayoutKeymaps'), keymap)

  local result = M.try(function()
    keymap[1] =	keymap[1][layout]
  end):catch 'UnresolvedKeymapError'

  if not result.success then return nil end

  return keymap
end

local function readonly(t)
  return setmetatable({}, {
    __index = t,
    __newindex = function(_, key)
      error("Attempt to modify read-only table", 2)
    end,
    __metatable = false
  })
end

local VALID_OPTS = readonly {
  noremap = true,
  nowait = true,
  silent = true,
  expr = true,
  unique = true,
  script = true,
  desc = true,
  callback = true,
  replace_keycodes = true,
  remap = true,
  buffer = true,
}

-- It's meant to be used when which-key is not installed
local function recursive_keymap(tbl, inherited_opts)
  -- Inherit valid opts
  local inherited_opts = inherited_opts or {}
  local opts = {}
  local mode = inherited_opts.mode
  for k, v in pairs(inherited_opts) do
    if VALID_OPTS[k] then opts[k] = v end
  end
  
  -- Override/add local valid opts
  for k, v in pairs(tbl) do
    if VALID_OPTS[k] then opts[k] = v end
    if k == 'mode' then mode = k end
  end
  
  -- Handle a keymap definition in this table if present
  if type(tbl[1]) == 'string' and tbl[2] ~= nil then
    vim.keymap.set(mode or 'n', tbl[1], tbl[2], opts)
  end
  
  -- Recurse into child tables
  for _, v in ipairs(tbl) do
    if type(v) == "table" then
      M.try(
        recursive_keymap, 
        v, 
        vim.tbl_extend(
          "force", 
          { mode = tbl.mode or inherited_opts.mode }, 
          opts
        )
      ):catch 'KeymapError'
    end
  end
end

-- Default keymapper
function M.map(spec)
  local wk = M.try(require, 'which-key'):catch 'MissingMappingLibrary'

  if wk.success then
    return wk().add(spec)
  end

  recursive_keymap(spec)
end

return M
