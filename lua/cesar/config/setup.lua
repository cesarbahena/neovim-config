User = "cesar"
Keyboard = "colemak"
vim.g.mapleader = " "

local opts = {
	-- Lines
	number = true,
	relativenumber = true,
	fillchars = { eob = " " },
	signcolumn = "yes",
	colorcolumn = nil,

	-- Formatting
	tabstop = 2,
	softtabstop = 2,
	shiftwidth = 2,
	expandtab = true,
	smartindent = true,
	wrap = false,

	-- Backup
	swapfile = false,
	backup = false,
	undofile = true,
	undodir = os.getenv("HOME") .. "/.vim/undodir",

	-- Search
	hlsearch = false,
	incsearch = true,
	updatetime = 50,
	ignorecase = true, -- Ignore case when searching...
	smartcase = true, -- ... unless there is a capital letter in the query

	-- Windows
	termguicolors = true,
	equalalways = false, -- I don't like my windows changing all the time
	splitright = true, -- Prefer windows splitting to the right
	splitbelow = true, -- Prefer windows splitting to the bottom
	scrolloff = 8,

	-- Statusline
	showmode = false,
	showcmd = false,
	cmdheight = 0,
	laststatus = 3,
	showcmdloc = "statusline",

	-- Folding
	foldmethod = "expr",
	foldexpr = "nvim_treesitter#foldexpr()",
	foldenable = false,

	-- Completion
	completeopt = { "menu", "menuone", "noselect" },
	wildmode = "longest:full",
}

for k, v in pairs(opts) do
	vim.opt[k] = v
end

require(User .. ".config.keymaps")
require(User .. ".config.autocmd")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(User, {
	lockfile = vim.fn.stdpath("config") .. "/lua/" .. User .. "/lazy-lock.json",
	install = {
		colorscheme = { "catppuccin" },
	},
	ui = {
		border = "rounded",
	},
})
