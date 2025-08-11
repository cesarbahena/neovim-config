vim.g.mapleader = ' '

-- Setup global variables and functions first
require('globals').setup()
try {
  require,
  { 'core.package_manager' },
  { 'core.options' },
  { 'core.keymaps' },
  { 'core.lsp' },
}
