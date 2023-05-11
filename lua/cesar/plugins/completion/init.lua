return {
  {
    "hrsh7th/nvim-cmp",
    config = function()
      require(vim.g.user..'.plugins.completion.mappings')
      require(vim.g.user..'.plugins.completion.config')
    end,
  },
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-nvim-lua",
  "hrsh7th/cmp-nvim-lsp",
  "tamago324/cmp-zsh",
  require(vim.g.user..'.plugins.completion.ui'),
  require(vim.g.user..'.plugins.completion.snips'),
  'rafamadriz/friendly-snippets',
  {
    "zbirenbaum/copilot.lua",
    config = true,
  },
  {
    "zbirenbaum/copilot-cmp",
    config = true,
  },
}
