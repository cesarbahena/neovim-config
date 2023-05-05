return function()
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
