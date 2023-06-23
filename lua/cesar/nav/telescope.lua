return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.1",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = function()
    local ok, telescope = pcall(require, User .. ".nav.pickers")
    if ok then
      return {
        {
          desc = "Find files",
          "<leader>fp",
          telescope("fd", "wide"),
        },
        {
          desc = "Find git files",
          "<leader>fg",
          telescope("git_files", "dropdown"),
        },
        {
          desc = "Edit neovim config",
          "<leader>fn",
          telescope("fd", "padded", {
            prompt_title = "Find in Neovim config",
            cwd = "~/.config/nvim/lua/" .. User,
          }),
        },
        {
          desc = "Find installed plugins",
          "<leader>fi",
          telescope("fd", "padded", {
            prompt_title = "Find installed plugins",
            cwd = vim.fn.stdpath("data") .. "/lazy/",
          }),
        },
        {
          desc = "Live grep",
          "<leader>fl",
          telescope("live_grep", "ivy", {
            previewer = false,
          }),
        },
        {
          desc = "Find word",
          "<leader>fw",
          function()
            require("telescope.builtin").grep_string(require("telescope.themes").get_ivy({
              search = vim.fn.input("> grep "),
              word_match = "-w",
              only_sort_text = true,
              path_display = { "shorten" },
            }))
          end,
        },
        {
          desc = "Find last search",
          "<leader>f/",
          function()
            require("telescope.builtin").grep_string(require("telescope.themes").get_ivy({
              search = vim.fn.getreg("/"):gsub("\\<", ""):gsub("\\>", ""):gsub("\\C", ""),
              word_match = "-w",
              only_sort_text = true,
              path_display = { "shorten" },
            }))
          end,
        },
        {
          desc = "Find buffers",
          "<leader>fb",
          telescope("buffers", "dropdown"),
        },
        {
          desc = "Find current buffer",
          "<leader>ff",
          telescope("current_buffer_fuzzy_find", "dropdown"),
        },
        {
          desc = "Git status",
          "<leader>gs",
          telescope("git_status", "dropdown", {}),
        },
        {
          desc = "Git commit",
          "<leader>gc",
          telescope("git_commits", "dropdown", {}),
        },
        {
          desc = "Find help",
          "<leader>fh",
          telescope("help_tags", "ivy", {
            attach_mappings = function(_, map)
              local actions = require("telescope.actions")
              map("i", "<C-y>", actions.file_edit)
              map("i", "<CR>", actions.file_edit)
              return true
            end,
          }),
        },
        {
          desc = "Find help",
          "<leader>fm",
          telescope("man_pages", "ivy", {
            attach_mappings = function(_, map)
              local actions = require("telescope.actions")
              map("i", "<C-y>", actions.select_vertical)
              map("i", "<CR>", actions.select_vertical)
              return true
            end,
          }),
        },
        {
          desc = "Find keymaps",
          "<leader>fk",
          telescope("keymaps", "ivy", {}),
        },
        {
          desc = "Find VIM options",
          "<leader>fo",
          telescope("vim_options", "padded", {}),
        },
        {
          desc = "Find builtin",
          "<leader>fB",
          telescope("builtin", "tiny"),
        },
        {
          desc = "Find yanks/deletes",
          "<leader>fy",
          telescope("neoclip", "wide", nil, "neoclip"),
        },
        {
          desc = "Find notifications",
          "<leader>n",
          telescope("notify", "wide", nil, "notify"),
        },
      }
    end
  end,
  opts = function()
    local telescope = require("telescope")
    local opts = {
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
          },
          n = {
            ["<C-e>"] = "close",
          },
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
        project = {
          base_dirs = {
            "~/Projects",
          },
        },
      },
    }

    if telescope.extensions.file_browser then
      local file_browser = telescope.extensions.file_browser.actions
      opts.extensions.file_browser = {
        theme = "ivy",
        hijack_netrw = true,
        hidden = true,
        mappings = {
          ["i"] = {
            ["<C-c>"] = file_browser.create_from_prompt,
            ["<C-d>"] = file_browser.remove,
            ["<C-r>"] = file_browser.rename,
            ["<C-t>"] = file_browser.move,
            ["<C-p>"] = file_browser.copy,
            ["<C-h>"] = file_browser.goto_home_dir,
          },
        },
      }
    end

    return opts
  end,

  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)

    local extensions = {
      "fzf",
      "neoclip",
      "ui-select",
      "notify",
    }

    for _, extension in ipairs(extensions) do
      pcall(telescope.load_extension, extension)
    end

    require(User .. ".nav.pickers") -- Mappings
  end,
}
