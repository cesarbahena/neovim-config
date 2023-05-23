local opt = vim.opt

vim.g.mapleader = " "
vim.g.netrw_banner = 0
opt.termguicolors = true

-- Lines
opt.number = true
opt.relativenumber = true
opt.fillchars = { eob = " " }
opt.signcolumn = "yes"
opt.colorcolumn = nil

-- Formatting
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.wrap = false

-- Backup
opt.swapfile = false
opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

-- Search
opt.hlsearch = false
opt.incsearch = true
opt.updatetime = 50
opt.ignorecase = true -- Ignore case when searching...
opt.smartcase = true -- ... unless there is a capital letter in the query

-- Windows
opt.equalalways = false -- I don't like my windows changing all the time
opt.splitright = true -- Prefer windows splitting to the right
opt.splitbelow = true -- Prefer windows splitting to the bottom
opt.scrolloff = 8

-- Statusline
opt.showmode = false
opt.showcmd = false
opt.cmdheight = 0
opt.laststatus = 3
opt.showcmdloc = "statusline"

-- Completion
opt.wildignore = "__pycache__"
opt.wildignore:append({ "*.o", "*~", "*.pyc", "*pycache*" })
opt.wildignore:append({ "Cargo.lock", "Cargo.Bazel.lock" })
opt.pumblend = 17
opt.wildmode = "longest:full"
opt.wildoptions = "pum"
opt.completeopt = { "menu", "menuone", "noselect" }
opt.shortmess:append("c")

-- Folds
-- opt.foldmethod = 'syntax'

-- General
opt.cpoptions = opt.cpoptions + "I" -- Don't trim whitespace when moving right after auto indent
opt.formatoptions = opt.formatoptions
	- "a" -- Auto formatting is BAD.
	- "t" -- Don't auto format my code. I got linters for that.
	+ "c" -- In general, I like it when comments respect textwidth
	+ "q" -- Allow formatting comments w/ gq
	- "o" -- O and o, don't continue comments
	+ "r" -- But do continue when pressing enter.
	+ "j" -- Auto-remove comments if possible.
