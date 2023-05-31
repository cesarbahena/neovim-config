return {
  "ahmedkhalf/project.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    {
      "notjedi/nvim-rooter.lua",
      config = function()
        require("nvim-rooter").setup({
          exclude_filetypes = { "harpoon" },
        })
      end,
    },
  },
  config = function()
    require("project_nvim").setup({
      manual_mode = true,
    })
  end,
}
