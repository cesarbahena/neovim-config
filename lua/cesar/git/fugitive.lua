return function()
  Keymap({
    [""] = {
      { "Git status", "<leader>gs", "<cmd>vert Git<CR>" },
    },
  })

  local Fugitive = vim.api.nvim_create_augroup("Fugitive", {})
  local autocmd = vim.api.nvim_create_autocmd
  autocmd("BufWinEnter", {
    group = Fugitive,
    pattern = "*",
    callback = function()
      if vim.bo.ft ~= "fugitive" then
        return
      end
      Keymap({
        [""] = {
          { "Git push", "<leader>p", vim.cmd.Git("push") },
          { "Git push", "<leader>gp", ":Git push -u origin" },
          { "Git pull", "<leader>P", vim.cmd.Git("pull") },
          { "Close", "<C-e>", "<cmd>q<CR>" },
        }, { buffer = true }
      })
    end,
  })
end
