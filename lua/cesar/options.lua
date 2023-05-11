vim.g.mapleader = " "
vim.g.netrw_banner = 0
-- vim.g.netrw_liststyle = 3

vim.opt.termguicolors = true
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.fillchars = {eob=' '}
vim.opt.colorcolumn = nil
vim.opt.signcolumn = "yes"

vim.opt.scrolloff = 8
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.updatetime = 50

vim.opt.cmdheight = 0
vim.opt.laststatus = 3
vim.opt.showcmdloc = 'statusline'
vim.opt.isfname:append("@-@")

vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append "c"
