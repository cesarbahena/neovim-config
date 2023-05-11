function ColorMyPencils(color)
  color = color or "rose-pine"
  vim.cmd.colorscheme(color)
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
{
  'tjdevries/colorbuddy.vim',
  config = function ()
    require(vim.g.user..'.plugins.colors.colorscheme')
    require(vim.g.user..'.plugins.colors.config')
  end,
  lazy = false,
  -- priority = 3000,
},
'tjdevries/gruvbuddy.nvim',
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
        flavour = 'mocha',
      })
      -- ColorMyPencils('catppuccin')
    end,
  },
}
