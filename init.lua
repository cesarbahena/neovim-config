vim.g.mapleader = ' '

-- Setup global variables and functions first
require('globals').setup()

-- Setup backup reload system
require('utils.backup_reload').setup()

try {
  require,
  { 'core.package_manager' },
  { 'core.options' },
  { 'core.keymaps' },
  { 'core.lsp' },
}
