return function()
  Keymap({
    [""] = {
      { "Git status", "gs", function() vim.cmd("vert Git") end },
    },
  })

  vim.api.nvim_create_autocmd ("BufWinEnter", {
    group = vim.api.nvim_create_augroup("Fugitive", {}),
    pattern = "*",
    callback = function()
      if vim.bo.ft ~= "fugitive" then
        return
      end
      Keymap({
        [""] = {
          { "Git push", "gp", function() vim.cmd.Git("push") end },
          { "Git push", "gP", ":Git push -u origin " },
          { "Git pull", "gl", function() vim.cmd.Git("pull") end },
          { "Close", "<C-e>", vim.cmd.q },
        }, { buffer = true }
      })
    end,
  })
end
