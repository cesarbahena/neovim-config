_G.KeyboardLayout = "colemak"
vim.keymap.set("", "<space>", "<nop>")

vim.g.mapleader = " "

local utils = require 'config.utils'
local try = utils.try
local resolve = utils.resolve

utils.map {
  --[[Normal mode]]
  { desc = "Substitute (w/o yank)", "s", [["_c]] },
  { desc = "Substitute to eol (w/o yank)", "ss", [["_C]] },
  { desc = "Yank line", "Y", "yy" },
  { desc = "Yank to eol", "yy", "y$" },
  { desc = "Yank line to clipboard", "<leader>Y", [["+yy]] },
  { desc = "Paste from clipboard", "<leader>p", [["+P]] },
  { desc = "Paste from clipboard in new line", "<leader>P", [[o<Esc>"+p]] },
  { desc = "Copy down", "yp", "Yp" },
  { desc = "Redo", "U", "<C-r>" },
  resolve({ desc = "Undo last jump", { colemak = "<C-u>", qwerty = "<C-i>" }, "<C-o>" }),
  resolve({ desc = "Redo last jump", { colemak = "<C-y>", qwerty = "<C-o>" }, "<C-i>" }),
  resolve({ desc = "Insert comma at the end", { colemak = ",k", qwerty = ",n" }, "mzA,<Esc>`z" }),
  resolve({ desc = "Insert semicolon at the end", { colemak = ",h", qwerty = ",m" }, "mzA;<Esc>`z" }),
  { desc = "Delete comma or semicolon at the end", ",d", "mz$x`z" },
  {
    desc = "Move line down",
    "<C-c>",
    "<cmd>execute 'move .+' . v:count1<cr>==",
  },
  {
    desc = "Move line up",
    "<C-s>",
    "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==",
  },
  resolve({ desc = "Join/Merge lines (pretty)", { colemak = "J", qwerty = "M" }, "mzJ`z" }),
  resolve({ desc = "Join/Merge lines (raw)", { colemak = "gJ", qwerty = "gM" }, "mzgJ`z" }),
  { desc = "Navigate to window to the left", "<C-w>m", "<C-w>h" },
  { desc = "Navigate to window below", "<C-w>n", "<C-w>j" },
  { desc = "Navigate to window above", "<C-w>e", "<C-w>k" },
  { desc = "Navigate to window to the right", "<C-w>o", "<C-w>l" },
  { desc = "Move window to leftmost side", "<C-w>m", "<C-w>H" },
  { desc = "Move window to top", "_", "<C-w>K" },
  { desc = "Move window to bottom", "<leader>_", "<C-w>J" },
  { desc = "Move window to leftmost side", "|", "<C-w>H" },
  { desc = "Move window to rightmost side", "<leader>|", "<C-w>L" },
  { desc = "Evenly distributed windows", "<leader>=", "<C-w>=" },
  {
    desc = "Replace current word",
    "<leader>s",
    ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
  },
  {
    desc = "Insert mode (indent blankline)",
    "i",
    function()
      if #vim.fn.getline(".") == 0 then
        return [["_cc]]
      else
        return "i"
      end
    end,
    expr = true,
  },
  {
    desc = "Delete line (don't yank blankline)",
    "D",
    function()
      if vim.api.nvim_get_current_line():match("^%s*$") then
        return '"_dd'
      else
        return "dd"
      end
    end,
    expr = true,
  },

  --[[Normal and visual mode]]
  {
    mode = {'x', 'n'},
    { desc = "Command line mode", "<CR>", ":"},
    resolve({
      desc = "Escape to normal mode and clear highlights",
      { colemak = "<C-e>", keymaps = "<C-k>" },
      function()
        vim.cmd("noh")
        return "<Esc>"
      end,
      expr = true,
    }),
    { desc = "Yank to clipboard", "<leader>y", [["+y]] },
    { desc = "Cmdline mode", "<CR>", ":" },
    resolve({ desc = "Open new Line below", { colemak = "l" }, "o" }),
    resolve({ desc = "Open new Line above", { colemak = "L" }, "O" }),
    { desc = "Substitute (same as change)", "s", "c" },
    resolve({
      desc = "Next line",
      { colemak = "n", qwerty = "j" },
      "v:count == 0 ? 'gj' : 'j'",
      expr = true,
      silent = true,
    }),
    resolve({ desc = "Scroll to Next page", { colemak = "N", qwerty = "J" }, "<C-d>zz" }),
    resolve({
      desc = "prEv line",
      { colemak = "e", qwerty = "j" },
      "v:count == 0 ? 'gk' : 'k'",
      expr = true,
      silent = true,
    }),
    resolve({ desc = "Scroll to prEv page", { colemak = "E", qwerty = "K" }, "<C-u>zz" }),
    resolve({ desc = "bacK one word", { colemak = "k" }, "b" }),
    resolve({ desc = "bacK one WORD", { colemak = "K" }, "B" }),
    { desc = "Word (rest of it)", "w", "e" },
    { desc = "WORD (rest of it)", "W", "E" },
    resolve({ desc = "Hop to next word", { colemak = "h", qwerty = "n" }, "w" }),
    resolve({ desc = "Hop to next WORD", { colemak = "H", qwerty = "N" }, "W" }),
    resolve({ desc = "Left", { colemak = "m" }, "h" }),
    resolve({ desc = "Right", { colemak = "o" }, "l" }),
    resolve({ desc = "HoMe (first non whitespace char)", { colemak = "M", qwerty = "H" }, "^" }),
    resolve({ desc = "EOL", { colemak = "O", qwerty = "L" }, "$" }),
    resolve({ desc = "Mark", { colemak = "j" }, "m" }),
    { desc = "Next match", "\\", "n" },
    { desc = "Delete into void register", "x", [["_x]] },
    { desc = "Quit", "<M-q>", vim.cmd.q },
  },

  --[[Visual mode]]
  {
    mode = { "x" },
    { desc = "Yank (keep position)", "y", "y`>" },
    { desc = "Yank to clipboard (keep position)", "<leader>y", [["+y`>]] },
    { desc = "Paste (w/o cutting)", "p", "P" },
    { desc = "Paste from clipboard (w/o cutting)", "<leader>p", [["+P]] },
    { desc = "Comment lines", "c", "gc" },
    {
      desc = "Move line down",
      "<C-c>",
      ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv",
    },
    {
      desc = "Move line up",
      "<C-s>",
      ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv",
    },
    {
      desc = "Change visual mode",
      "V",
      function()
        if vim.fn.mode():find("V") then
          return "v"
        end
        return "V"
      end,
      expr = true,
    },
  },

  --[[Insert mode]]
  {
    mode = { "i" },
    { desc = "Paste from clipboard", "<C-p>", [[<C-o>"+P]] },
    { desc = "Move line down", "<C-c>", "<esc><cmd>m .+1<cr>==gi" },
    { desc = "Move line up", "<C-s>", "<esc><cmd>m .-2<cr>==gi" },
    resolve({ desc = "Comma after bracket", { colemak = "<C-k>", qwerty = "<C-b>" }, ".<Esc>mzva{lva,<Esc>`za<BS>" }),
    resolve({ desc = "Semicolon after bracket", { colemak = "<C-h>", qwerty = "<C-h>" }, ".<Esc>mzva{lva;<Esc>`za<BS>" }),
    { desc = "Comma with auto undo breakpoints", ",", ",<C-g>u" },
    { desc = "Semicolon with auto undo breakpoints", ";", ";<C-g>u" },
    { desc = "Dot with auto undo breakpoints", ".", ".<C-g>u" },
    { desc = "Left", "<C-r>", "<Left>" },
    { desc = "Right", "<C-d>", "<Right>" },
  },

  --[[Command and Insert modes]]
  {
    mode = {'c', 'i'},
    resolve({
      desc = "Escape to normal mode",
      { colemak = "<C-e>", keymaps = "<C-k>" },
      "<Esc>"
    }),
    { desc = "Left", "<Right>", "<Left>"},
    { desc = "Right", "<M-o", "<Right>" },
  },
}
