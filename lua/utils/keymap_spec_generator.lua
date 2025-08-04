local M = {}

local key_descriptions = require('config.keymaps.' .. _G.KeyboardLayout)

-- Helper function to normalize description for lookup
local function normalize_desc(desc)
  return desc:lower():gsub('[%s%-_%*]', '')
end

-- Helper function to build key string from category and key
local function build_key(category, key)
  if category == 'keys' then
    return key  -- Use key as-is
  elseif category == 'control' then
    return '<c-' .. key .. '>'
  elseif category == 'alt' then
    return '<m-' .. key .. '>'
  elseif category == 'leader' then
    return '<leader>' .. key
  elseif category == 'local_leader' then
    return '<localleader>' .. key
  end
end

-- Build initial lookup from structured table
local description_to_key = {}
for category, keys in pairs(key_descriptions) do
  for key, desc_or_table in pairs(keys) do
    local full_key = build_key(category, key)
    
    if type(desc_or_table) == 'string' then
      -- Single description
      local normalized = normalize_desc(desc_or_table)
      if description_to_key[normalized] then
        error(
          'Duplicate description found: "' 
          .. desc_or_table 
          .. '" normalizes to "' 
          .. normalized 
          .. '" which conflicts with existing key "' 
          .. description_to_key[normalized] 
          .. '"'
        )
      end
      description_to_key[normalized] = full_key

    elseif type(desc_or_table) == 'table' then
      -- Multiple descriptions - add each to lookup
      for _, desc in pairs(desc_or_table) do
        local normalized = normalize_desc(desc)
        if description_to_key[normalized] then
          error(
            'Duplicate description found: "' 
            .. desc 
            .. '" normalizes to "' 
            .. normalized 
            .. '" which conflicts with existing key "' 
            .. description_to_key[normalized] .. '"'
          )
        end
        description_to_key[normalized] = full_key
      end
    end
  end
end

-- vim.print(description_to_key)
-- Function to rebuild reverse lookup when key_descriptions changes
local function rebuild_lookup()
  description_to_key = {}
  for category, keys in pairs(key_descriptions) do
    for key, desc in pairs(keys) do
      local full_key = build_key(category, key)
      description_to_key[normalize_desc(desc)] = full_key
    end
  end
end

-- Core spec generator function
local function make_spec(mode, desc, rhs, opts)
  local normalized = normalize_desc(desc)
  local lhs = description_to_key[normalized]
  if not lhs then
    error('No key found for description: ' .. desc)
  end
  
  local spec = { lhs, rhs, desc = desc, mode = mode }
  
  if not opts then return spec end
  
  if opts.details then
    spec.desc = desc .. ' ' .. opts.details
  end
  
  for k, v in pairs(opts) do
    -- Don't copy details to the final spec
    if k ~= 'details' then
      spec[k] = v
    end
  end
  
  return spec
end

-- Mode-specific helper functions
function M.normal(desc, rhs, opts)
  return make_spec('n', desc, rhs, opts)
end

function M.insert(desc, rhs, opts)
  return make_spec('i', desc, rhs, opts)
end

function M.visual(desc, rhs, opts)
  return make_spec('x', desc, rhs, opts)
end

function M.command(desc, rhs, opts)
  return make_spec('c', desc, rhs, opts)
end

function M.terminal(desc, rhs, opts)
  return make_spec('t', desc, rhs, opts)
end

function M.pending(desc, rhs, opts)
  return make_spec('o', desc, rhs, opts)
end

-- Mode combinations
function M.motion(desc, rhs, opts)
  return make_spec({ 'n', 'o', 'x' }, desc, rhs, opts)
end

function M.operator(desc, rhs, opts)
  return make_spec({ 'o', 'x' }, desc, rhs, opts)
end

function M.edit(desc, rhs, opts)
  return make_spec({ 'n', 'x' }, desc, rhs, opts)
end

-- Helper function to create lazy function calls
function M.fn(fn_or_module, ...)
  -- Direct function case: wrap it with args
  if type(fn_or_module) == 'function' then
    local args = { ... }
    return function()
      return fn_or_module(unpack(args))
    end
  end

  -- Module case: return a function that can be called with method name or custom function
  if type(fn_or_module) ~= 'string' then
    error('Expected function or string, got ' .. type(fn_or_module))
  end

  return function(module_fn_or_custom_fn, ...)
    local args = { ... }
    return function()
      local module = require(fn_or_module)
      
      -- Custom function case: call it with the module as parameter
      if type(module_fn_or_custom_fn) == 'function' then
        return module_fn_or_custom_fn(module)
      end
      
      -- Method name case: call the method on the module with args
      local module_fn = module[module_fn_or_custom_fn]
      
      if not module_fn then
        error('Function ' .. tostring(module_fn_or_custom_fn) .. ' not found in module ' .. fn_or_module)
      end
      
      return module_fn(unpack(args))
    end
  end
end

-- Helper for command strings with <CR>
function M.cmd(command)
  return '<cmd>' .. command .. "<cr>"
end

-- Helper functions
function M.get_key(desc)
  return description_to_key[desc]
end

function M.get_description(key)
  return key_descriptions[key]
end

function M.add_key_mapping(category, key, desc)
  if not key_descriptions[category] then
    key_descriptions[category] = {}
  end
  key_descriptions[category][key] = desc
  rebuild_lookup()
end

function M.update_key_mapping(category, old_key, new_key)
  if key_descriptions[category] and key_descriptions[category][old_key] then
    local desc = key_descriptions[category][old_key]
    key_descriptions[category][old_key] = nil
    key_descriptions[category][new_key] = desc
    rebuild_lookup()
  end
end

-- Expose internals
M.key_descriptions = key_descriptions
M.rebuild_lookup = rebuild_lookup
M.make_spec = make_spec

return M
