_G.KeyboardLayout = "colemak"

local utils = require 'config.utils'
local try = utils.try
local resolve = utils.resolve

try(utils.map, {
  --[[Normal mode]]
  { '<cr>', ':', desc = 'Command line mode' },
  { "s", [["_c]], desc = "Substitute (w/o yank)" },
  -- { "ss", [["_C]], desc = "Substitute to eol (w/o yank)" },
  -- { "dd", 'd$', desc = "Delete to eol (w/o yank)" },
  { "Y", "yy", desc = "Yank line" },
  { "yy", "y$", desc = "Yank to eol" },
  { "<leader>Y", [["+yy]], desc = "Yank line to clipboard" },
  { "<leader>p", [["+P]], desc = "Paste from clipboard" },
  { "<leader>P", [[o<Esc>"+p]], desc = "Paste from clipboard in new line" },
  { "yp", "Yp", desc = "Copy down" },
  { 'C', 'gcc', desc = 'Toggle Comment', remap = true },
  { 'cc', 'gc$', desc = 'Toggle Comment', remap = true },
  { "U", "<C-r>", desc = "Redo" },
  { 'gUU', 'gUl', desc = 'Uppercase' },
  { 'gUu', 'g~', desc = 'Swap case' },
  { 'guu', 'gul', desc = 'Lowercase' },
  { 'guU', 'g~', desc = 'Swap case' },
  resolve({ { colemak = "<C-u>", qwerty = "<C-i>" }, "<C-o>", desc = "Undo last jump" }),
  resolve({ { colemak = "<C-y>", qwerty = "<C-o>" }, "<C-i>", desc = "Redo last jump" }),
  resolve({ { colemak = ",k", qwerty = ",n" }, "mzA,<Esc>`z", desc = "Insert comma at the end" }),
  resolve({ { colemak = ",h", qwerty = ",m" }, "mzA;<Esc>`z", desc = "Insert semicolon at the end" }),
  { ",d", "mz$x`z", desc = "Delete comma or semicolon at the end" },
  {
    "<C-d>",
    "<cmd>execute 'move .+' . v:count1<cr>==",
    desc = "Move line down",
  },
  {
    "<C-s>",
    "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==",
    desc = "Move line up",
  },
  resolve({ { colemak = "J", qwerty = "M" }, "mzJ`z", desc = "Join/Merge lines (pretty)" }),
  resolve({ { colemak = "gJ", qwerty = "gM" }, "mzgJ`z", desc = "Join/Merge lines (raw)" }),
  { "<C-w>m", "<C-w>h", desc = "Navigate to window to the left" },
  { "<C-w>n", "<C-w>j", desc = "Navigate to window below" },
  { "<C-w>e", "<C-w>k", desc = "Navigate to window above" },
  { "<C-w>o", "<C-w>l", desc = "Navigate to window to the right" },
  { "<C-w>m", "<C-w>H", desc = "Move window to leftmost side" },
  { "_", "<C-w>K", desc = "Move window to top" },
  { "<leader>_", "<C-w>J", desc = "Move window to bottom" },
  { "|", "<C-w>H", desc = "Move window to leftmost side" },
  { "<leader>|", "<C-w>L", desc = "Move window to rightmost side" },
  { "<leader>=", "<C-w>=", desc = "Evenly distributed windows" },
  {
    "i",
    function()
      if #vim.fn.getline(".") == 0 then
        return [["_cc]]
      else
        return "i"
      end
    end,
    desc = "Insert mode (indent blankline)",
    expr = true,
  },
  {
    "D",
    function()
      if vim.api.nvim_get_current_line():match("^%s*$") then
        return '"_dd'
      end
      return "dd"
    end,
    desc = "Delete line (don't yank blankline)",
    expr = true,
  },
  { '>', '>>', desc = 'Indent' },
  { '<', '<<', desc = 'Deindent' },
  resolve({ { colemak = "l" }, "o", desc = "Open new Line below" }),
  resolve({ { colemak = "L" }, "O", desc = "Open new Line above" }),

  --[[Normal and visual mode]]
  {
    mode = {'x', 'n'},
    { "s", [["_c]], desc = "Substitute (w/o yank)" },
    { 'c', 'gc', desc = 'Toggle Comment', remap = true },
    resolve({
      { colemak = "<C-e>", keymaps = "<C-k>" },
      "<cmd>noh<cr><C-c>",
      desc = "Escape to normal mode and clear highlights",
    }),
    { "<leader>y", [["+y]], desc = "Yank to clipboard" },
    { "\\", "n", desc = "Next match" },
    resolve{ { colemak = 'do', qwerty = 'dl' }, [["_x]], desc = "Delete into void register" },
    resolve{ { colemak = 'so', qwerty = 'sl' }, 'r', desc = 'Substitute letter and back to normal mode' },
    { "<M-q>", vim.cmd.q, desc = "Quit" },
  },

  --[[Visual mode]]
  {
    mode = { "x" },
    { "y", "y`>", desc = "Yank (keep position)" },
    { "<leader>y", [["+y`>]], desc = "Yank to clipboard (keep position)" },
    { "p", "P", desc = "Paste (w/o cutting)" },
    { "<leader>p", [["+P]], desc = "Paste from clipboard (w/o cutting)" },
    { '>', '>gv', desc = 'Indent' },
    { '<', '<gv', desc = 'Deindent' },
    { 'U', 'nop' },
    { 'gU', 'U', desc = 'Uppercase' },
    { 'u', 'nop' },
    { 'gu', 'u', desc = 'Lowercase' },
    {
      "<C-d>",
      ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv",
      desc = "Move line down",
    },
    {
      "<C-s>",
      ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv",
      desc = "Move line up",
    },
    {
      "V",
      function()
        if vim.fn.mode():find("V") then
          return "v"
        end
        return "V"
      end,
      desc = "Change visual mode",
      expr = true,
    },
  },

  --[[Insert mode]]
  {
    mode = { "i" },
    resolve({
      { colemak = "<C-e>", keymaps = "<C-k>" },
      "<C-c>",
      desc = "Escape to normal mode"
    }),
    { "<C-d>", "<esc><cmd>m .+1<cr>==gi", desc = "Move line down" },
    { "<C-s>", "<esc><cmd>m .-2<cr>==gi", desc = "Move line up" },
    { ",", ",<C-g>u", desc = "Comma with auto undo breakpoints" },
    { ";", ";<C-g>u", desc = "Semicolon with auto undo breakpoints" },
    { ".", ".<C-g>u", desc = "Dot with auto undo breakpoints" },
    { "<C-k>", "<Left>", desc = "Left" },
    { "<C-h>", "<Right>", desc = "Right" },
  },

  --[[Normal, visual and OP mode]]
  {
    mode = { 'n', 'x', 'o' },
    resolve({
      { colemak = "n", qwerty = "j" },
      "v:count == 0 ? 'gj' : 'j'",
      desc = "Next line",
      expr = true,
      silent = true,
    }),
    resolve({
      { colemak = "N", qwerty = "J" },
      "<C-d>zz",
      desc = "Scroll to Next page",
    }),
    resolve({
      { colemak = "e", qwerty = "j" },
      "v:count == 0 ? 'gk' : 'k'",
      desc = "prEv line",
      expr = true,
      silent = true,
    }),
    resolve({
      { colemak = "E", qwerty = "K" },
      "<C-u>zz",
      desc = "Scroll to prEv page",
    }),
    resolve({ { colemak = "k" }, "b", desc = "bacK one word" }),
    resolve({ { colemak = "K" }, "B", desc = "bacK one WORD" }),
    { "w", "e", desc = "Word (rest of it)" },
    { "W", "E", desc = "WORD (rest of it)" },
    resolve({ { colemak = "h", qwerty = "n" }, "w", desc = "Hop to next word" }),
    resolve({ { colemak = "H", qwerty = "N" }, "W", desc = "Hop to next WORD" }),
    resolve({ { colemak = "m" }, "h", desc = "Left" }),
    resolve({ { colemak = "o" }, "l", desc = "Right" }),
    resolve({ { colemak = "M", qwerty = "H" }, "^", desc = "HoMe (first non whitespace char)" }),
    resolve({ { colemak = "O", qwerty = "L" }, "$", desc = "EOL" }),
  },

  --[[Command and Insert modes]]
  {
    mode = {'c', 'i'},
    resolve({
      { colemak = "<C-e>", keymaps = "<C-k>" },
      "<C-c>",
      desc = "Escape to normal mode"
    }),
    { "<C-u>", "<BS>", desc = "Backspace" },
  },
})
