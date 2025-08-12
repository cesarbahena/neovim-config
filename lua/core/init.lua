vim.g.mapleader = ' '

_G.try = require('utils.try').try

try {
  require,
  { 'core.globals' },
  { 'core.keymaps' },
  { 'core.options' },
  { 'core.lsp' },
}

-- Retry failed modules before lazy.nvim initialization
local retry = require 'core.retry'
if retry.has_retryable_errors() then retry.retry_failed_modules() end

try(require, 'core.package_manager')
