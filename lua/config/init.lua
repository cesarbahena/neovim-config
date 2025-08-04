vim.g.mapleader = " "

try(require, 'config.lazy'):catch 'LoadModuleError'

try(require, 'config.options'):catch 'LoadModuleError'

local keymapper, ok = try(require, 'utils.keymapper')
  :catch('LoadModuleError')()
if ok then
  keymapper.map(require 'config.keymaps')
end
