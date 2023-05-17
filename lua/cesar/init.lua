User = 'cesar'

local modules = {
  'globals',
  'options',
  'mappings',
  'autocmd',
}

for _, module in ipairs(modules) do
  require(User .. '.' .. module)
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(User .. '.plugins')
