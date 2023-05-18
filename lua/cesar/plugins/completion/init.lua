return {
  {
    "hrsh7th/nvim-cmp",
    config = function()
      Plugin 'completion.mappings'
      Plugin 'completion.setup'
    end,
  },
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-nvim-lua",
  "hrsh7th/cmp-nvim-lsp",
  "tamago324/cmp-zsh",
  Plugin 'completion.ui',
  Plugin 'completion.snips.init',
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
