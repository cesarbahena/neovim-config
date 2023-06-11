local u = "https://github.com/chrisgrieser/nvim-various-textobjs"
return function()
  require("various-textobjs").setup({
    useDefaultKeymaps = true,
    disabledKeymaps = { "n" },
  })

  local keymaps = require(User .. ".config.keymaps")
  keymaps({
    n = {
      {
        "Go to Link",
        "gl",
        function()
          vim.fn.setreg("z", "")
          require("various-textobjs").url()
          vim.cmd.normal({ '"zy', bang = true })
          local url = vim.fn.getreg("z")

          if url == "" then
            vim.cmd.UrlView("buffer")
            return
          end

          local opener
          if vim.fn.has("wsl") == 1 then
            opener = "wslview"
          elseif vim.fn.has("macunix") == 1 then
            opener = "open"
          elseif vim.fn.has("linux") == 1 then
            opener = "xdg-open"
          elseif vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 then
            opener = "start"
          end

          local open_cmd = string.format("%s %s >/dev/null 2>&1", opener, url)
          os.execute(open_cmd)
        end,
      },
      {
        "Delete Surrounding Indentation",
        "dsi",
        function()
          require("various-textobjs").indentation(true, true)
          -- plugin only switches to visual mode when textobj found
          local notOnIndentedLine = vim.fn.mode():find("V") == nil
          if notOnIndentedLine then
            return
          end
          -- dedent indentation
          vim.cmd.normal({ ">", bang = true })
          -- delete surrounding lines
          local endBorderLn = vim.api.nvim_buf_get_mark(0, ">")[1] + 1
          local startBorderLn = vim.api.nvim_buf_get_mark(0, "<")[1] - 1
          vim.cmd(tostring(endBorderLn) .. " delete") -- delete end first so line index is not shifted
          vim.cmd(tostring(startBorderLn) .. " delete")
        end,
      },
    },
    [{ "o", "v" }] = {
      { "Inner Subword", "is", [[<cmd>lua require("various-textobjs").subword(true)<CR>]] },
      { "Inner Subword", "as", [[<cmd>lua require("various-textobjs").subword(false)<CR>]] },
      { "Near EoL",      ",",  [[<cmd>lua require("various-textobjs").nearEoL()<CR>]] },
    },
  })
end
