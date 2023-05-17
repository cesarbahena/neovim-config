return {
  {
    "hrsh7th/nvim-cmp",
    config = function()
      require 'completion.mappings'
      require 'completion.config'
    end,
  },
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-nvim-lua",
  "hrsh7th/cmp-nvim-lsp",
  "tamago324/cmp-zsh",
  require 'completion.ui',
  require 'completion.snips.init',
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

-- local function new(args)
--
-- end
