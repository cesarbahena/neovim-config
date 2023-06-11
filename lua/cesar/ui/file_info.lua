local M = {}

M.cwd = {
  "%{fnamemodify(getcwd(), ':t')}",
  icon = " ",

  color = function()
    local dx = vim.diagnostic
    if #dx.get(nil, { severity = dx.severity.ERROR }) > 0 then
      return "StatuslineError"
    end
    if #dx.get(nil, { severity = dx.severity.WARN }) > 0 then
      return "StatuslineWarn"
    end
    return "StatuslineNormal"
  end,
}

M.git = {
  "branch",
  icon = "",
  color = function()
    local gs = vim.fn.systemlist("git status --porcelain " .. vim.fn.expand("%:p"))
    if #gs == 0 then
      return "StatuslineWarn"
    end
    vim.fn.systemlist("git diff --quiet " .. vim.fn.expand("%"))
    if vim.v.shell_error == 1 then
      return "StatuslineOk"
    end
    return "StatuslineNormal"
  end,
}

M.filetype = {
  "filetype",
  icon_only = true,
  colored = true,

  cond = function()
    local exclude = {
      netrw = true,
      TelescopePrompt = true,
      fugitive = true,
      harpoon = true,
      lspinfo = true,
      ["null-ls-info"] = true,
    }
    return not exclude[vim.bo.ft]
  end,

  padding = { left = 1, right = 0 },
}

M.filename = {
  function()
    local fname = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":t")
    if fname == "" then
      return ""
    end

    local parent = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":h:t")
    return parent .. "/" .. fname
  end,

  color = function()
    local dx = vim.diagnostic
    if #dx.get(0, { severity = dx.severity.ERROR }) > 0 then
      return "StatuslineError"
    end
    if #dx.get(0, { severity = dx.severity.WARN }) > 0 then
      return "StatuslineWarn"
    end
    if vim.o.modified then
      return "StatuslineOk"
    end
    return "StatuslineNormal"
  end,
}

return M
