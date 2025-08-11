vim.g.mapleader = ' '

-- Setup global variables and functions first
require('globals').setup()
require 'core.package_manager'
require 'core.options'
require 'core.keymaps'
require 'core.lsp'

