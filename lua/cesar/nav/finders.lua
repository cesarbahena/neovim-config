local telescope = require(User .. ".nav.pickers")
local keymaps = require(User .. ".config.keymaps")

keymaps({
  [""] = {
    {
      "Find files",
      "<leader>fp",
      telescope("fd", "wide"),
    },
    {
      "Find git files",
      "<leader>fg",
      telescope("git_files", "dropdown"),
    },
    {
      "Edit neovim config",
      "<leader>fn",
      telescope("fd", "padded", {
        prompt_title = "Find in Neovim config",
        cwd = "~/.config/nvim/lua/" .. User,
      }),
    },
    {
      "Find installed plugins",
      "<leader>fi",
      telescope("fd", "padded", {
        prompt_title = "Find installed plugins",
        cwd = vim.fn.stdpath("data") .. "/lazy/",
      }),
    },
    {
      "Live grep",
      "<leader>fl",
      telescope("live_grep", "ivy", {
        previewer = false,
      }),
    },
    {
      "Find word",
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
      "Find last search",
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
      "Find buffers",
      "<leader>fb",
      telescope("buffers", "dropdown"),
    },
    {
      "Find current buffer",
      "<leader>ff",
      telescope("current_buffer_fuzzy_find", "dropdown"),
    },
    {
      "Git status",
      "<leader>gs",
      telescope("git_status", "dropdown", {}),
    },
    {
      "Git commit",
      "<leader>gc",
      telescope("git_commits", "dropdown", {}),
    },
    {
      "Find help",
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
      "Find help",
      "<leader>fm",
      telescope("man_pages", "ivy", {}),
    },
    {
      "Find keymaps",
      "<leader>fk",
      telescope("keymaps", "ivy", {}),
    },
    {
      "Find VIM options",
      "<leader>fo",
      telescope("vim_options", "padded", {}),
    },
    {
      "Find builtin",
      "<leader>fB",
      telescope("builtin", "tiny"),
    },
    {
      "File tree",
      "<leader>ft",
      function()
        require("telescope").extensions.file_browser.file_browser(require("telescope.themes").get_ivy({
          cwd = vim.fn.expand("%:p:h"),
        }))
      end,
    },
    {
      "Find projects",
      "<leader>fa",
      telescope("project", "tiny", nil, "project"),
    },
    {
      "Frecency",
      "<leader>fr",
      telescope("frecency", "wide", nil, "frecency"),
    },
    {
      "Find yanks/deletes",
      "<leader>fy",
      telescope("neoclip", "wide", nil, "neoclip"),
    },
    {
      "Find notifications",
      "<leader>n",
      telescope("notify", "wide", nil, "notify"),
    },
  },
})
