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
}

for k, v in pairs(opts) do
	vim.opt[k] = v
end
