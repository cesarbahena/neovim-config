local M = {}
local extensions = {
  file_browser = {
    "nvim-telescope/telescope-file-browser.nvim",
    keys = function()
      local ok, telescope = pcall(require, User .. ".nav.pickers")
      if ok then
        return {
          {
            desc = "File tree",
            "<leader>ft",
            function()
              require("telescope").extensions.file_browser.file_browser(
                require("telescope.themes").get_ivy({
                  cwd = vim.fn.expand("%:p:h"),
                })
              )
            end,
          },
        }
      end
    end,
  },

  project = {
    "nvim-telescope/telescope-project.nvim",
    keys = function()
      local ok, telescope = pcall(require, User .. ".nav.pickers")
      if ok then
        return {
          {
            desc = "Find projects",
            "<leader>fa",
            telescope("project", "tiny", nil, "project"),
          },
        }
      end
    end,
  },

  frecency = {
    "nvim-telescope/telescope-frecency.nvim",
    dependencies = { "kkharji/sqlite.lua" },
    keys = function()
      local ok, telescope = pcall(require, User .. ".nav.pickers")
      if ok then
        return {
          {
            desc = "Frecency",
            "<leader>fr",
            telescope("frecency", "wide", nil, "frecency"),
          },
        }
      end
    end,
  },
}

for name, spec in pairs(extensions) do
  spec.dependencies = spec.dependencies or {}
  table.insert(spec.dependencies, { "nvim-telescope/telescope.nvim" })
  spec.config = function()
    local ok, telescope = pcall(require, "telescope")
    if ok then
      telescope.load_extension(name)
    end
  end
  table.insert(M, spec)
end

return M
