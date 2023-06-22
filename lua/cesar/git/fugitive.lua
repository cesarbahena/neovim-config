return {
  "tpope/vim-fugitive",
  keys = {
    {
      desc = "Git status",
      "gs",
      function()
        vim.cmd("vert Git")
      end,
    },
  },
  config = function()
    local keymaps = require(User .. ".config.keymaps")
    local autocmd = require(User .. ".config.autocmd")

    autocmd({
      "FileType",
      "Fugitive",
      pattern = "fugitive",
      function()
        keymaps({
          n = {
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
  end,
}
