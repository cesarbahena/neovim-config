return {
  "ahmedkhalf/project.nvim",
  dependencies = {
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
    require("project_nvim").setup({ manual_mode = true })
    require("telescope").load_extension("projects")
  end,
}
