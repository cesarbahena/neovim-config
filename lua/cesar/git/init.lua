return {
  require(User .. ".git.fugitive"),
  require(User .. ".git.signs"),
  {
    "mbbill/undotree",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<CR><C-w><C-h><C-w><C-k>" },
    },
  },
}
