return function()
  local keymaps = require(User .. ".config.keymaps")
  local autocmd = require(User .. ".config.autocmd")

  keymaps({
    [""] = {
      {
        "Git status",
        "gs",
        function()
          vim.cmd("vert Git")
        end,
      },
    },
  })

  autocmd({
    "BufWinEnter",
    "Fugitive",
    function()
      if vim.bo.ft ~= "fugitive" then
        return
      end
      keymaps({
        [""] = {
          {
            "Git push",
            "<leader>p",
            function()
              vim.cmd.Git("push")
            end,
          },
          { "Git push", "<leader>gp", ":Git push -u origin" },
          {
            "Git pull",
            "<leader>P",
            function()
              vim.cmd.Git("pull")
            end,
          },
          { "Close",    "<C-e>",      vim.cmd.q },
        },
      }, { buffer = true })
    end,
  })
end
