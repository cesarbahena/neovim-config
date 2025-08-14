---@class KeyAutoRegister
local M = {}

local spec_gen = require('utils.keymap_spec_generator')

-- Save current key_descriptions to JSON with fixed category order and sorted keys
local function save_to_json()
  local config_path = vim.fn.stdpath('config') .. '/json/' .. _G.KeyboardLayout .. '.json'
  
  -- Fixed category order
  local category_order = { 'keys', 'leader', 'control', 'alt', 'local_leader' }
  
  -- Build sorted structure
  local sorted_data = {}
  for _, category in ipairs(category_order) do
    if _G.key_descriptions[category] then
      -- Sort keys within each category
      local keys = _G.key_descriptions[category]
      local sorted_keys = {}
      for key in pairs(keys) do
        table.insert(sorted_keys, key)
      end
      table.sort(sorted_keys)
      
      -- Build sorted category
      sorted_data[category] = {}
      for _, key in ipairs(sorted_keys) do
        sorted_data[category][key] = keys[key]
      end
    end
  end
  
  local encoded = vim.json.encode(sorted_data)
  vim.fn.writefile(vim.split(encoded, '\n'), config_path)
end

-- Scan for missing key descriptions in content
function M.scan_for_missing_keys(content)
  local missing = {}
  
  -- List of all helper functions that use the key system
  local key_functions = {
    'key', 'motion', 'operator', 'auto_select', 'on_selection', 'insert'
  }
  
  -- Create pattern to match any of these functions
  local pattern = '(' .. table.concat(key_functions, '|') .. ')%s*{%s*[\'"]([^\'"]+)[\'"]'
  
  for func_name, desc in content:gmatch(pattern) do
    -- Test if the description exists in the lookup table
    local success = pcall(spec_gen.key, { desc })
    if not success then
      table.insert(missing, desc)
    end
  end
  
  return missing
end

-- Prompt for key assignment
local function prompt_for_key(desc)
  local categories = { k = 'keys', c = 'control', l = 'leader', a = 'alt' }
  
  local cat_input = vim.fn.input('Category for "' .. desc .. '"? [k/c/l/a]: ')
  local category = categories[cat_input:lower()]
  
  if not category then
    vim.notify('Invalid category', vim.log.levels.WARN)
    return
  end
  
  local key = vim.fn.input('Key for "' .. desc .. '": ')
  if key == '' then
    vim.notify('No key provided', vim.log.levels.WARN)
    return
  end
  
  -- Use existing add_key_mapping to update in-memory
  spec_gen.add_key_mapping(category, key, desc)
  
  -- Save to JSON
  save_to_json()
  
  vim.notify('Added: ' .. key .. ' → "' .. desc .. '"')
end

-- Handle missing keys
function M.handle_missing_keys(missing_keys)
  if #missing_keys == 0 then return end
  
  for _, desc in ipairs(missing_keys) do
    prompt_for_key(desc)
  end
end

-- Setup autocommand
function M.setup()
  vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = '*.lua',
    group = vim.api.nvim_create_augroup('KeyAutoRegister', { clear = true }),
    callback = function()
      local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n')
      local missing = scan_for_missing_keys(content)
      
      if #missing > 0 then
        vim.schedule(function()
          M.handle_missing_keys(missing)
        end)
      end
    end,
  })
end

return M