return function()
  local telescope = require("telescope")
  local fb_actions = require("telescope").extensions.file_browser.actions

  telescope.setup({
    defaults = {
      color_devicons = true,
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
        },
        n = {
          ["<C-e>"] = "close",
        },
      },
    },
    extensions = {
      file_browser = {
        theme = "ivy",
        hijack_netrw = true,
        hidden = true,
        mappings = {
          ["i"] = {
            ["<C-c>"] = fb_actions.create_from_prompt,
            ["<C-d>"] = fb_actions.remove,
            ["<C-r>"] = fb_actions.rename,
            ["<C-t>"] = fb_actions.move,
            ["<C-p>"] = fb_actions.copy,
            ["<C-h>"] = fb_actions.goto_home_dir,
          },
        },
      },
    },
  })

  local extensions = {
    "fzf",
    "neoclip",
    "frecency",
    "file_browser",
  }

  for _, extension in ipairs(extensions) do
    telescope.load_extension(extension)
  end

  require(User .. ".nav.finders")
end
