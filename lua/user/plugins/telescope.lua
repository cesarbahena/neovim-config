return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.1',
    lazy = false,
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>f', '<cmd>Telescope find_files<CR>' },
    },
    config = function()
      require 'telescope'.setup {
        defaults = {
          winblend = 10,
          layout_strategy = "horizontal",
          layout_config = {
            width = 0.95,
            height = 0.85,
            -- preview_cutoff = 120,
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
          sorting_strategy = "descending",
          scroll_strategy = "cycle",
          color_devicons = true,
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          -- file_ignore_patterns = nil,

          history = {
            path = "~/.local/share/nvim/databases/telescope_history.sqlite3",
            limit = 100,
          },
        },
      }
    end
  },
}