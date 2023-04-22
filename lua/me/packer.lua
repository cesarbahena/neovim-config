return require 'packer'.startup(function(use)
  use 'wbthomason/packer.nvim'

  -- LSP
  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v1.x',
    requires = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lua' },
      -- Snippets
      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },
    }
  }

  -- Treesitter
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'nvim-treesitter/nvim-treesitter-context'
  use 'nvim-treesitter/playground'

  -- Completion
  use 'folke/neodev.nvim'
  use 'github/copilot.vim'

  -- Formatters
  use 'jose-elias-alvarez/null-ls.nvim'
  use 'MunifTanjim/prettier.nvim'

  use 'mfussenegger/nvim-dap'

  -- Telescope
  use 'nvim-lua/plenary.nvim'
  use {"nvim-telescope/telescope.nvim",
    priority = 100,
  }
  use "nvim-telescope/telescope-file-browser.nvim"
  use "nvim-telescope/telescope-hop.nvim"
  use "nvim-telescope/telescope-ui-select.nvim"
  use { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
  use 'rcarriga/nvim-notify'
  use 'nvim-telescope/telescope-smart-history.nvim'
  use {
    "nvim-telescope/telescope-frecency.nvim",
    requires = {"kkharji/sqlite.lua"}
  }
  use {
    "ThePrimeagen/git-worktree.nvim",
    config = function()
      require("git-worktree").setup {}
    end,
  }
 use {
    "AckslD/nvim-neoclip.lua",
    config = function()
      require("neoclip").setup()
    end,
  }


  use {
    'folke/trouble.nvim',
    config = function()
      require('trouble').setup {
        icons = true,
      }
    end
  }
  use 'tpope/vim-fugitive'
  use 'mbbill/undotree'
  use 'theprimeagen/harpoon'
  use 'ggandor/leap.nvim'

  -- Debug
  use  "mfussenegger/nvim-dap"
  use  "rcarriga/nvim-dap-ui"
  use  "theHamsta/nvim-dap-virtual-text"
  use  "nvim-telescope/telescope-dap.nvim"
  use  { "leoluz/nvim-dap-go" }
  use  { "mfussenegger/nvim-dap-python" }
  use  "jbyuki/one-small-step-for-vimkind"

  -- UI
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }
  use 'vzze/cmdline.nvim'
  use 'rose-pine/neovim'
  use 'folke/zen-mode.nvim'
  use 'j-hui/fidget.nvim'
  use 'nvim-tree/nvim-web-devicons'

  -- Utils
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }
  use 'theprimeagen/refactoring.nvim'
end)
