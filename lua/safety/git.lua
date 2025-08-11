local M = {}

-- Create git-ignored backup from current config
function M.create_backup_snapshot()
  local config_path = vim.fn.stdpath 'config'
  local backup_path = config_path .. '/lua/backup'

  -- Check if we're in a git repository
  local is_git_repo = vim.fn.isdirectory(config_path .. '/.git') == 1

  if is_git_repo then
    -- Get current git commit for reference
    local commit = vim.fn.system('cd ' .. config_path .. ' && git rev-parse --short HEAD'):gsub('\n', '')

    -- Copy current working state to backup
    vim.fn.system(string.format("rsync -av --exclude='.git' --exclude='lua/backup' %s/ %s/", config_path, backup_path))

    -- Create backup info file
    local info = {
      created = os.date '%Y-%m-%d %H:%M:%S',
      source_commit = commit,
      neovim_version = vim.version(),
      backup_type = 'manual_snapshot',
    }

    local info_file = io.open(backup_path .. '/backup_info.json', 'w')
    if info_file then
      info_file:write(vim.json.encode(info))
      info_file:close()
    end

    vim.notify('Backup snapshot created from commit ' .. commit, vim.log.levels.INFO)
  else
    vim.notify('Not in git repository, creating basic backup', vim.log.levels.WARN)
    require('safety.fallback').ensure_backup_config()
  end

  -- Ensure backup is in .gitignore
  M.update_gitignore()
end

-- Update .gitignore to exclude backup
function M.update_gitignore()
  local gitignore_path = vim.fn.stdpath 'config' .. '/.gitignore'
  local gitignore_content = {}

  -- Read existing .gitignore
  local file = io.open(gitignore_path, 'r')
  if file then
    for line in file:lines() do
      table.insert(gitignore_content, line)
    end
    file:close()
  end

  -- Check if backup is already ignored
  local backup_ignored = false
  for _, line in ipairs(gitignore_content) do
    if line:match 'nvim%-backup' then
      backup_ignored = true
      break
    end
  end

  -- Add backup to .gitignore if not present
  if not backup_ignored then
    table.insert(gitignore_content, '')
    table.insert(gitignore_content, '# Safety system backup (auto-generated)')
    table.insert(gitignore_content, 'lua/backup/')

    file = io.open(gitignore_path, 'w')
    if file then
      for _, line in ipairs(gitignore_content) do
        file:write(line .. '\n')
      end
      file:close()
      vim.notify('Updated .gitignore to exclude backup directory', vim.log.levels.INFO)
    end
  end
end

return M
