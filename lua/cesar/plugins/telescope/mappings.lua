local M = {}

function M.commands()
  local tele_cmd = require(vim.g.user..'.utils').tele_cmd

  -- Dotfiles
  tele_cmd("<leader>en", "edit_neovim")
  tele_cmd("<leader>ez", "edit_zsh")
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
  tele_cmd("<space>gs", "git_status")
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
end

function M.ui()
  local actions = require 'telescope.actions'
  require 'telescope'.setup {
    defaults = {
      mappings = {
        i = {
          ['<C-e>'] = actions.close,
          ['<RightMouse>'] = actions.close,
          ["<LeftMouse>"] = actions.select_default,
          ["<ScrollWheelDown>"] = actions.move_selection_next,
          ["<ScrollWheelUp>"] = actions.move_selection_previous,
          ["<C-x>"] = false,
          ["<C-s>"] = actions.select_horizontal,
          ["<C-n>"] = "move_selection_next",
          ["<C-d>"] = actions.results_scrolling_down,
          ["<C-u>"] = actions.results_scrolling_up,
          -- ["<C-y>"] = set_prompt_to_entry_value,

          -- ["<M-p>"] = action_layout.toggle_preview,
          -- ["<M-m>"] = action_layout.toggle_mirror,
          -- ["<M-p>"] = action_layout.toggle_prompt_position,
          -- ["<M-m>"] = actions.master_stack,
          -- ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          -- ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

          -- This is nicer when used with smart-history plugin.
          ["<C-h>"] = actions.cycle_history_next,
          ["<C-k>"] = actions.cycle_history_prev,
          ["<C-g>s"] = actions.select_all,
          ["<C-g>a"] = actions.add_selection,
        },
      },
    },
  }
end

return M
