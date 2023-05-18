local M = {}

M.cwd = {
  "%{fnamemodify(getcwd(), ':t')}",
  icon = ' ',
}

M.git = {
  'branch',
  icon = '',
  color = function ()
    vim.fn.systemlist("git diff --quiet " .. vim.fn.expand('%'))
    if vim.v.shell_error == 1 then
      return { fg = 'orange' }
    end
  end
}

M.filetype = {
  'filetype',
  cond = function () return vim.bo.ft ~= 'netrw' end,
  icon_only = true,
  colored = false,
  color = function ()
    local dx = vim.diagnostic
    if #dx.get(0, { severity = dx.severity.ERROR }) > 0 then
      return { fg = 'orange' }
    elseif #dx.get(0, { severity = dx.severity.WARN }) > 0 then
      return { fg = 'yellow' }
    end
  end,
  padding = { left = 1, right = 0 },
}

M.filename = {
  function ()
    return vim.fn.fnamemodify(vim.fn.expand '%:p', ':t:r')
  end,
  color = function ()
    local dx = vim.diagnostic
    if #dx.get(0, { severity = dx.severity.ERROR }) > 0 then
      return { fg = 'orange' }
    elseif #dx.get(0, { severity = dx.severity.WARN }) > 0 then
      return { fg = 'yellow' }
    end
  end,
}

M.write_status = {
  function ()
    if vim.o.modified then
      return ''
    end
    return ''
  end,
  padding = { left = 0 },
}

return M
