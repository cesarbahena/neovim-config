return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  config = function()
    require('catppuccin').setup {
      flavour = 'mocha',
      transparent_background = true,
      integrations = {
        -- cmp = true,
        -- gitsigns = true,
        --   nvimtree = true,
        --   telescope = true,
        notify = false,
      },
    }
    vim.cmd.colorscheme('catppuccin')
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  end,
}
