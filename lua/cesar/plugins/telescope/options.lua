return function()
  require 'telescope'.setup {
    defaults = {
      -- winblend = 15,
      layout_strategy = "horizontal",
      layout_config = {
        width = 0.95,
        height = 0.85,
        prompt_position = "top",
        horizontal = {
          preview_width = function(_, cols, _)
            if cols > 200 then
              return math.floor(cols * 0.4)
            else
              return math.floor(cols * 0.6)
            end
          end,
        },
        vertical = {
          width = 0.9,
          height = 0.95,
          preview_height = 0.5,
        },
        flex = {
          horizontal = {
            preview_width = 0.9,
          },
        },
      },
      sorting_strategy = "ascending",
      scroll_strategy = "cycle",
      color_devicons = true,
      history = {
        path = "~/.local/share/nvim/databases/telescope_history.sqlite3",
      },
    },
  }
end
