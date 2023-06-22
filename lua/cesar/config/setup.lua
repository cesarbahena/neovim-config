User = "cesar"
Keyboard = "colemak"

vim.g.mapleader = " "
vim.undodir = os.getenv("HOME") .. "/.vim/undodir"

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

local hl_groups = {
	StatuslineNormal = { fg = "white", bold = true },
	StatuslineOk = { fg = "LightGreen", bold = true },
	StatuslineError = { fg = "#f38ba8", bold = true },
	StatuslineWarn = { fg = "#f9e2af", bold = true },
	StatuslineInfo = { fg = "#f9e2af", bold = true },
}

for hl_group, hl in pairs(hl_groups) do
	vim.api.nvim_set_hl(0, hl_group, hl)
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
	install = {
		colorscheme = { "catppuccin" },
	},
})
