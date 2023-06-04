local function autocmd(args)
  local event = args[1]
  local buffer = args[4]

  local group
  if args.clear == false then
    group = vim.api.nvim_create_augroup(args[2], { clear = false })
  else
    group = vim.api.nvim_create_augroup(args[2], {})
  end

  local callback, command
  if type(args[3]) == "function" then
    callback = args[3]
  else
    command = args[3]
  end

  vim.api.nvim_create_autocmd(event, {
    group = group,
    callback = callback,
    command = command,
    buffer = buffer,
    pattern = args.pattern,
    once = args.once,
  })
end

-- User autocommands
autocmd({
  "BufEnter",
  "SetOptions",
  "setlocal cpoptions=aABceFIs_ formatoptions=crqj",
})

autocmd({
  "TextYankPost",
  "HighlightYank",
  function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 40,
    })
  end,
})

return autocmd
