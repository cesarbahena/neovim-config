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

local keymaps = require(User .. ".config.keymaps")

-- User autocommands
autocmd({
  "BufEnter",
  "SetOptions",
  "setlocal cpoptions=aABceFIs_ formatoptions=crqj",
})

vim.api.nvim_set_hl(0, "LineNrBelow", { link = "none" })
vim.api.nvim_set_hl(0, "LineNrAbove", { link = "none" })

autocmd({
  "ModeChanged",
  "VisualMode",
  pattern = "*:[vV\x16]*",
  function()
    vim.api.nvim_set_hl(0, "LineNr", { link = "Visual" })
  end,
})

autocmd({
  "ModeChanged",
  "OtherModes",
  pattern = "*:[^vV\x16]*",
  function()
    vim.api.nvim_set_hl(0, "LineNr", { link = "none" })
  end,
})

autocmd({
  "FileType",
  "Docs",
  pattern = { "gitcommit", "markdown" },
  function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    keymaps({
      [""] = {
        {
          "Next linewrap",
          { colemak = "n", qwerty = "j" },
          "v:count == 0 ? 'gj' : 'j'",
        },
        {
          "prEv linewrap",
          { colemak = "e", qwerty = "k" },
          "v:count == 0 ? 'gk' : 'k'",
        },
      },
    }, { expr = true })
  end,
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

autocmd({
  "QuitPre",
  "UnsavedChanges",
  function()
    if vim.o.modified then
      Modified = true
      vim.defer_fn(function()
        Modified = false
      end, 5000)
    end
  end,
})

autocmd({
  "FileType",
  "CloseOnCancel",
  pattern = {
    "qf",
    "notify",
    "noice",
    "man",
    "lazy",
    "lspinfo",
    "null-ls-info",
    "tsplayground",
  },
  function()
    keymaps({
      n = {
        { "Disabled", "<C-n>", "<nop>" },
        { "Close",    "<C-e>", vim.cmd.q },
        { "Disabled", "<C-i>", "<nop>" },
        { "Disabled", "<C-o>", "<nop>" },
      },
    }, { buffer = true })
  end,
})

autocmd({
  "FileType",
  "GoToFileOnEnter",
  pattern = "qf",
  function()
    keymaps({
      n = {
        { "Go to file", "<CR>", "<CR>" },
      },
    }, { buffer = true })
  end,
})

return autocmd
