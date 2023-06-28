return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.1",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "folke/trouble.nvim",
  },
  keys = require(User .. ".nav.builtin"),
  opts = function()
    local _, trouble = pcall(require, "trouble.providers.telescope")
    return {
      defaults = {
        history = {
          path = "~/.local/share/nvim/databases/telescope_history.sqlite3",
        },
        mappings = {
          i = {
            ["<C-e>"] = "close",
            ["<C-l>"] = "move_selection_previous",
            ["<C-y>"] = "select_default",
            ["<C-b>"] = "cycle_history_next",
            ["<C-p>"] = "cycle_history_prev",
            ["<C-a>"] = "toggle_all",
            ["<C-t>"] = trouble.open_with_trouble,
          },
          n = {
            ["<C-e>"] = "close",
          },
        },
      },
    }
  end,
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)

    local extensions = {
      "fzf",
      "neoclip",
      "notify",
    }

    for _, extension in ipairs(extensions) do
      pcall(telescope.load_extension, extension)
    end
  end,
}

