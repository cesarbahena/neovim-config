local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local themes = require "telescope.themes"
local tele_cmd = require(User .. '.utils').tele_cmd

local set_prompt_to_entry_value = function(prompt_bufnr)
  local entry = action_state.get_selected_entry()
  if not entry or not type(entry) == "table" then
    return
  end
  action_state.get_current_picker(prompt_bufnr):reset_prompt(entry.ordinal)
end

local M = {}


-- Dotfiles
tele_cmd("<space><space>d", "diagnostics")

-- Search
tele_cmd("<space>gw", "grep_string", {
  word_match = "-w",
  short_path = true,
  only_sort_text = true,
  layout_strategy = "vertical",
})

tele_cmd("<space>f/", "grep_last_search", {
  layout_strategy = "vertical",
})

-- Files
tele_cmd("<space>fg", "git_files")
-- tele_cmd("<space>fg", "multi_rg")
tele_cmd("<space>fo", "oldfiles")
tele_cmd("<space>fd", "find_files")
tele_cmd("<space>fs", "fs")

tele_cmd("<space>pp", "project_search")
tele_cmd("<space>fv", "find_nvim_source")
tele_cmd("<space>fe", "file_browser")
tele_cmd("<space>fz", "search_only_certain_files")

-- Git
tele_cmd("<space>fgs", "git_status")
tele_cmd("<space>gc", "git_commits")

-- Nvim
tele_cmd("<space>fb", "buffers")
-- tele_cmd("<space>fp", "my_plugins")
tele_cmd("<space>fa", "installed_plugins")
tele_cmd("<space>fi", "search_all_files")
tele_cmd("<space>ff", "curbuf")
tele_cmd("<space>fh", "help_tags")
tele_cmd("<space>bo", "vim_options")
tele_cmd("<space>gp", "grep_prompt")
tele_cmd("<space>wt", "treesitter")

-- Telescope Meta
tele_cmd("<space>fB", "builtin")



tele_cmd("<leader>en", "edit_neovim")
function M.edit_neovim()
  local opts_with_preview = {
    prompt_title = "~ dotfiles ~",
    shorten_path = false,
    cwd = "~/.config/nvim",
    layout_strategy = "flex",
    layout_config = {
      width = 0.9,
      height = 0.8,
      horizontal = {
        width = { padding = 0.15 },
      },
      vertical = {
        preview_height = 0.75,
      },
    },
    mappings = {
      i = {
        ["<C-y>"] = false,
      },
    },
    attach_mappings = function(_, map)
      map("i", "<C-y>", set_prompt_to_entry_value)
      map("i", "<C-e>", function(prompt_bufnr)
        actions.close(prompt_bufnr)
        vim.schedule(function()
          require("telescope.builtin").find_files(opts_without_preview)
        end)
      end)
      return true
    end,
  }

  local opts_without_preview = vim.deepcopy(opts_with_preview)
  opts_without_preview.previewer = false

  require("telescope.builtin").find_files(opts_with_preview)
end

tele_cmd("<leader>ez", "edit_zsh")
function M.edit_zsh()
  require("telescope.builtin").find_files {
    shorten_path = false,
    cwd = "~/.config/zsh/",
    prompt = "~ dotfiles ~",
    hidden = true,
    layout_strategy = "horizontal",
    layout_config = {
      preview_width = 0.55,
    },
  }
end

function M.find_files()
  require("telescope.builtin").find_files {
    scroll_strategy = "cycle",
    layout_config = {
      -- height = 10,
    },
  }
end

function M.fs()
  local opts = themes.get_ivy { hidden = false, sorting_strategy = "descending" }
  require("telescope.builtin").find_files(opts)
end


function M.builtin()
  require("telescope.builtin").builtin()
end

function M.git_files()
  local path = vim.fn.expand "%:h"
  if path == "" then
    path = nil
  end

  local opts = themes.get_dropdown {
    winblend = 5,
    previewer = false,
    shorten_path = false,
    cwd = path,
    layout_config = {
      width = width,
    },
  }
  require("telescope.builtin").git_files(opts)
end

function M.buffer_git_files()
  require("telescope.builtin").git_files(themes.get_dropdown {
    cwd = vim.fn.expand "%:p:h",
    winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false,
  })
end

function M.lsp_code_actions()
  local opts = themes.get_dropdown {
    winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false,
  }
  require("telescope.builtin").lsp_code_actions(opts)
end

function M.live_grep()
  require("telescope.builtin").live_grep {
    -- shorten_path = true,
    previewer = false,
    fzf_separator = "|>",
  }
end

function M.grep_prompt()
  require("telescope.builtin").grep_string {
    path_display = { "shorten" },
    search = vim.fn.input "Grep String > ",
  }
end

function M.grep_last_search(opts)
  opts = opts or {}
  -- \<getreg\>\C
  -- -> Subs out the search things
  local register = vim.fn.getreg("/"):gsub("\\<", ""):gsub("\\>", ""):gsub("\\C", "")
  opts.path_display = { "shorten" }
  opts.word_match = "-w"
  opts.search = register
  require("telescope.builtin").grep_string(opts)
end

function M.oldfiles()
  require("telescope").extensions.frecency.frecency(themes.get_ivy {})
end

function M.installed_plugins()
  require("telescope.builtin").find_files {
    cwd = vim.fn.stdpath "data" .. "/lazy/",
  }
end

function M.project_search()
  require("telescope.builtin").find_files {
    previewer = false,
    layout_strategy = "vertical",
    cwd = require("nvim_lsp.util").root_pattern ".git"(vim.fn.expand "%:p"),
  }
end

function M.buffers()
  require("telescope.builtin").buffers {
    shorten_path = false,
  }
end

function M.curbuf()
  local opts = themes.get_dropdown {

    -- winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false,

  }
  require("telescope.builtin").current_buffer_fuzzy_find(opts)
end

function M.help_tags()
  require("telescope.builtin").help_tags {
    show_version = true,
  }
end

function M.search_all_files()
  require("telescope.builtin").find_files {
    find_command = { "rg", "--no-ignore", "--files" },
  }

end

function M.file_browser()
  local opts

  opts = {
    sorting_strategy = "ascending",
    scroll_strategy = "cycle",
    layout_config = {
      prompt_position = "top",
    },

    attach_mappings = function(prompt_bufnr, map)
      local current_picker = action_state.get_current_picker(prompt_bufnr)

      local modify_cwd = function(new_cwd)
        local finder = current_picker.finder

        finder.path = new_cwd
        finder.files = true
        current_picker:refresh(false, { reset_prompt = true })
      end


      map("i", "-", function()
        modify_cwd(current_picker.cwd .. "/..")
      end)

      map("i", "~", function()
        modify_cwd(vim.fn.expand "~")
      end)

      -- local modify_depth = function(mod)
      --   return function()
      --     opts.depth = opts.depth + mod
      --
      --     current_picker:refresh(false, { reset_prompt = true })
      --   end
      -- end
      --
      -- map("i", "<M-=>", modify_depth(1))
      -- map("i", "<M-+>", modify_depth(-1))


      map("n", "yy", function()
        local entry = action_state.get_selected_entry()

        vim.fn.setreg("+", entry.value)
      end)


      return true
    end,
  }

  require("telescope").extensions.file_browser.file_browser(opts)
end

function M.git_status()
  local opts = themes.get_dropdown {
    winblend = 10,
    border = true,
    previewer = false,

    shorten_path = false,
  }

  -- Can change the git icons using this.
  -- opts.git_icons = {

  --   changed = "M"
  -- }

  require("telescope.builtin").git_status(opts)

end

function M.git_commits()

  require("telescope.builtin").git_commits {
    winblend = 5,
  }

end

function M.search_only_certain_files()

  require("telescope.builtin").find_files {
    find_command = {
      "rg",
      "--files",
      "--type",
      vim.fn.input "Type: ",
    },
  }
end


function M.lsp_references()
  require("telescope.builtin").lsp_references {
    layout_strategy = "vertical",
    layout_config = {
      prompt_position = "top",
    },
    sorting_strategy = "ascending",
    ignore_filename = false,
  }
end

function M.lsp_implementations()
  require("telescope.builtin").lsp_implementations {
    layout_strategy = "vertical",

    layout_config = {
      prompt_position = "top",
    },

    sorting_strategy = "ascending",
    ignore_filename = false,
  }

end

function M.vim_options()

  require("telescope.builtin").vim_options {
    layout_config = {
      width = 0.5,
    },
    sorting_strategy = "ascending",
  }
end

return M
