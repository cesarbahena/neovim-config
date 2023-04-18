local map = vim.keymap.set
vim.g.mapleader = " "

-- Arrow motions
map("", "m", "b")
map("", "n", "j")
map("", "e", "k")
map("", "i", "w")
map("", "l", "e")
map("", "u", "h")
map("", "y", "l")

-- Quick movement
map("", "M", "B")
map("", "N", "<C-d>zz")
map("", "E", "<C-u>zz")
map("", "I", "W")
map("", "L", "E")
map("", "U", "^")
map("", "Y", "$")

-- Insert mode
map("", "d", "i") -- "Dis" text object
map("", "D", "I")
map("", "h", "a") -- "wHole" text object
map("", "H", "A")

-- Modes
map("n", "a", "v")
map("n", "aa", "V")
map("x", "a", "V")
map("", "A", "V")
map("", "<C-a>", "<C-v>")
map("", ";", ":")

-- Cut, copy, paste, undo
map("", "X", "dd")
map("", "x", "d")
map("", "xx", "dd")
map("", "<Del>", [["_dl]])
map("", "<S-Del>", [["_d]])

map("", "c", "y")
map("", "cc", "Y")
map("", "C", "Y")
map("n", "cv", "yyp")

map("n", "v", "p")
map("n", "V", "P")
map("x", "v", [["_dP]])

map("", "z", "u")
map("", "Z", "<C-r>")

-- Replace and search
map("", "r", "c")
map("", "R", "C")
map("", "<BS>", "r")
map("n", "?", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
map("n", "b", "nzzzv")
map("n", "B", "Nzzzv")
map("", "p", ";")
map("", "P", ",")

-- Buffer management
map("n", "<leader>pe", vim.cmd.Ex)
map("n", "<leader>w", vim.cmd.wa)
map("n", "<leader>qq", vim.cmd.wqa)
map("n", "q", vim.cmd.close)
map("n", "<leader>f", vim.lsp.buf.format)
map("n", "<leader><leader>", function()
  vim.cmd("so")
end)

-- Window navigation
map("", "<C-u>", "<C-o>")
map("", "<C-y>", "<C-i>")
map("", "w", "<C-w>")

-- Line management
map("v", "<C-n>", ":m '>+1<CR>gv=gv")
map("v", "<C-e>", ":m '<-2<CR>gv=gv")
map("n", "J", "mzJ`z")
map("n", "gJ", "mzgJ`z")
map("", ",", "z")
map("", "<leader>o", "o<Esc>")
map("", "<leader>O", "O<Esc>")

-- Word text object
map("", "adi", "viw")
map("", "adI", "viW")
map("", "ahi", "vaw")
map("", "ahI", "vaW")
map("", "rdi", "ciw")
map("", "rdI", "ciW")
map("", "rhi", "caw")
map("", "rhI", "caW")
map("", "xdi", "diw")
map("", "xdI", "diW")
map("", "xhi", "daw")
map("", "xhI", "daW")
map("", "cdi", "yiw")
map("", "cdI", "yiW")
map("", "chi", "yaw")
map("", "chI", "yaW")

-- Parentheses text object
map("", "ado", "vib")
map("", "adO", "viB")
map("", "aho", "vab")
map("", "ahO", "vaB")
map("", "rdo", "cib")
map("", "rdO", "ciB")
map("", "rho", "cab")
map("", "rhO", "caB")
map("", "xdo", "dib")
map("", "xdO", "diB")
map("", "xho", "dab")
map("", "xhO", "daB")
map("", "cdo", "yib")
map("", "cdO", "yiB")
map("", "cho", "yab")
map("", "chO", "yaB")

-- Quotation marks and paragraph text object
map("", "adm", [[vi"]])
map("", "adM", [[vip]])
map("", "ahm", [[va"]])
map("", "ahM", [[vap]])
map("", "rdm", [[ci"]])
map("", "rdM", [[cip]])
map("", "rhm", [[ca"]])
map("", "rhM", [[cap]])
map("", "xdm", [[di"]])
map("", "xdM", [[dip]])
map("", "xhm", [[da"]])
map("", "xhM", [[dap]])
map("", "cdm", [[yi"]])
map("", "cdM", [[yip]])
map("", "chm", [[ya"]])
map("", "chM", [[yap]])

-- Miscelaneous
map("n", "k", "nop")
map("", "Q", "q")
map("n", "<leader>qn", "<cmd>cnext<CR>zz")
map("n", "<leader>qe", "<cd>cprev<CR>zz")
map("n", "<leader>n", "<cmd>lnext<CR>zz")
map("n", "<leader>e", "<cmd>lprev<CR>zz")
map("n", "<C-d>", "<C-a>")
map("n", "<C-s>", "<C-x>")
map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
map("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");
map("n", "<leader>vp", "<cmd>e ~/.config/nvim/lua/cesar/packer.lua<CR>");
