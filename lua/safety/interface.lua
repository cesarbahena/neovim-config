local M = {}

-- Enhanced floating window with actions
function M.create_error_window(title, content, actions)
  local buf = vim.api.nvim_create_buf(false, true)

  -- Calculate optimal window size
  local max_width = math.floor(vim.o.columns * 0.8)
  local max_height = math.floor(vim.o.lines * 0.8)

  local content_width = math.max(unpack(vim.tbl_map(function(line) return vim.fn.strdisplaywidth(line) end, content)))

  local width = math.min(content_width + 4, max_width)
  local height = math.min(#content + 6, max_height)

  -- Set window content
  local display_lines = {}
  table.insert(display_lines, '')
  vim.list_extend(display_lines, content)
  table.insert(display_lines, '')
  table.insert(display_lines, 'Actions:')

  for i, action in ipairs(actions) do
    table.insert(display_lines, string.format('  %d. %s', i, action))
  end

  table.insert(display_lines, '')
  table.insert(display_lines, "Press number key to select action, 'q' to close")

  vim.api.nvim_buf_set_lines(buf, 0, -1, true, display_lines)

  -- Create floating window
  local win_opts = {
    relative = 'editor',
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = 'minimal',
    border = 'double',
    title = ' ' .. title .. ' ',
    title_pos = 'center',
  }

  local win = vim.api.nvim_open_win(buf, true, win_opts)

  -- Configure buffer
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')

  -- Set up keymaps for actions
  for i, action in ipairs(actions) do
    vim.api.nvim_buf_set_keymap(buf, 'n', tostring(i), '', {
      callback = function()
        vim.api.nvim_win_close(win, true)
        M.handle_action(i, actions, action)
      end,
      noremap = true,
      silent = true,
    })
  end

  -- Close keymap
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '', {
    callback = function() vim.api.nvim_win_close(win, true) end,
    noremap = true,
    silent = true,
  })

  return win, buf
end

-- Main error summary interface
function M.show_error_summary(errors)
  print("DEBUG: show_error_summary called with", #errors, "errors")
  if #errors == 0 then return end

  local content = {
    string.format('Configuration loaded with %d error(s):', #errors),
    '',
  }

  for i, error in ipairs(errors) do
    table.insert(content, string.format('Error %d: %s', i, error.module))
    table.insert(content, '  ' .. error.message:sub(1, 80) .. (error.message:len() > 80 and '...' or ''))
    table.insert(content, '')
  end

  local actions = {
    'Load my backup config (lua/backup/init.lua)',
    'Edit problematic files',
    'Retry failed modules',
    'Continue with current state',
    'Show detailed error log',
  }

  M.create_error_window('Configuration Errors Detected', content, actions)
end

-- Action handler
function M.handle_action(action_index, actions, action_text)
  if action_index == 1 then
    -- Load your backup configuration
    M.confirm_backup_load()
  elseif action_index == 2 then
    -- Edit problematic files
    M.open_error_files()
  elseif action_index == 3 then
    -- Retry failed modules
    M.retry_failed_modules()
  elseif action_index == 4 then
    -- Continue with current state
    vim.notify('Continuing with current configuration', vim.log.levels.INFO)
  elseif action_index == 5 then
    -- Show detailed error log
    M.show_detailed_errors()
  end
end

-- Backup configuration confirmation
function M.confirm_backup_load()
  vim.ui.select({ 'Yes, load my backup config', 'No, continue current' }, {
    prompt = 'Load your backup configuration (lua/backup/init.lua)?',
    format_item = function(item) return '• ' .. item end,
  }, function(choice)
    if choice and choice:match 'Yes' then 
      -- Clear existing errors before loading backup to avoid duplicates
      _G.Errors = {}
      _G.SAFETY.summary_shown = false
      
      -- Load backup config which handles all module reloading
      require('safety.fallback').load_backup_config()
    end
  end)
end

-- Open files with errors for editing
function M.open_error_files()
  -- Use _G.Errors from try function instead of old safety.errors
  for category, errors in pairs(_G.Errors or {}) do
    for _, error in ipairs(errors) do
      if error.module and error.line then
        local file_path = vim.fn.stdpath 'config' .. '/lua/' .. error.module .. '.lua'
        if vim.fn.filereadable(file_path) == 1 then
          vim.cmd('edit +' .. error.line .. ' ' .. file_path)
          return
        end
      end
    end
  end
end

-- Retry loading failed modules
function M.retry_failed_modules()
  vim.notify('Retrying failed modules...', vim.log.levels.INFO)
  
  -- Clear error state
  _G.Errors = {}
  
  -- Clear problematic modules from cache
  local modules_to_clear = {}
  for module_name, _ in pairs(package.loaded) do
    if module_name:match '^core%.' or 
       module_name:match '^plugins%.' or 
       module_name:match '^actions%.' or
       module_name:match '^utils%.' then
      table.insert(modules_to_clear, module_name)
    end
  end
  
  for _, module_name in ipairs(modules_to_clear) do
    package.loaded[module_name] = nil
  end

  -- Try to reload core modules using the safety system
  vim.schedule(function()
    local safety_core = require('safety.core')
    local success, result = pcall(function()
      -- Reload core modules
      return safety_core.load_config_level('core', {
        'core.options',
        'core.keymaps', 
        'core.lsp',
      }, true)
    end)
    
    if success then
      vim.notify('✓ Modules reloaded successfully', vim.log.levels.INFO)
    else
      vim.notify('Failed to reload modules: ' .. tostring(result), vim.log.levels.ERROR)
      vim.notify('Consider loading backup configuration or restarting Neovim', vim.log.levels.WARN)
    end
  end)
end

-- Show detailed error information
function M.show_detailed_errors()
  local all_errors = {}
  for category, errors in pairs(_G.Errors or {}) do
    for _, error in ipairs(errors) do
      table.insert(all_errors, error)
    end
  end

  if #all_errors == 0 then
    vim.notify('No errors to display', vim.log.levels.INFO)
    return
  end

  local content = { 'Detailed Error Information:', '' }

  for i, error in ipairs(all_errors) do
    table.insert(content, string.format('=== Error %d ===', i))
    table.insert(content, 'Module: ' .. (error.module or 'unknown'))
    table.insert(content, 'Line: ' .. (error.line or 'unknown'))
    table.insert(content, 'Category: ' .. (error.category or 'unknown'))
    table.insert(content, 'Time: ' .. (error.time or 'unknown'))
    table.insert(content, 'Message: ' .. (error.message or 'unknown'))
    
    if error.traceback and #error.traceback > 0 then
      table.insert(content, 'Traceback:')
      for _, trace in ipairs(error.traceback) do
        table.insert(content, '  ' .. trace)
      end
    end
    
    table.insert(content, '')
  end

  local actions = { 'Close', 'Copy to clipboard', 'Save to file' }
  M.create_error_window('Detailed Error Log', content, actions)
end

return M
