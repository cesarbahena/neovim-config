return function()
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

      -- These extensions are here because of lazy loading
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
end
