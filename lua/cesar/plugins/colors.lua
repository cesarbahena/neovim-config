function ColorMyPencils(color)
  color = color or "rose-pine"
  vim.cmd.colorscheme(color)
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
  {
    'rose-pine/neovim',
    config = function()
      require('rose-pine').setup({
        disable_background = true
      })
      -- ColorMyPencils('rose-pine')
    end,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup({
        transparent_background = true,
        flavour = 'mocha',
      })
      ColorMyPencils('catppuccin')
    end,
  },
}
