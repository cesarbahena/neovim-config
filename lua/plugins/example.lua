return {
  {
    "folke/which-key.nvim",
    lazy = true,
    config = function()
      require 'which-key'.add({
        {
        }
      })

    end
  },
  {
      "rebelot/kanagawa.nvim",
      lazy = false, 
      priority = 1000,
      init = function()
        vim.cmd('colorscheme kanagawa')
      end,
      opts = { 
        transparent = true,
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = "none"
              }
            }
          }
        }
      },
    }
 }
