vim.g.mapleader = ' '

-- Setup global variables and functions first
require('globals').setup()

try {
  require,
  { 'core.keymaps' },
  { 'core.options' },
  { 'core.lsp' },
  { 'core.package_manager' },
}
