vim.g.mapleader = ' '

-- Setup global variables and functions first
require('globals').setup()

-- Setup safe mode system
require('utils.safe_mode').setup()

try {
  require,
  { 'core.package_manager' },
  { 'core.options' },
  { 'core.keymaps' },
  { 'core.lsp' },
}
