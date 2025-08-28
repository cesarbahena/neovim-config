keymap {
  motion { 'Next line', "v:count == 0 ? 'gj' : 'j'", expr = true, silent = true },
  motion { 'next page', '<C-d>zz' },
  motion { 'prEv line', "v:count == 0 ? 'gk' : 'k'", expr = true, silent = true },
  motion { 'prev page', '<C-u>zz' },
  motion { 'prev word', 'b' },
  motion { 'end of word', 'e' },
  motion { 'move left', 'h' },
  motion { 'move right', 'l' },
  motion { 'repeat', '.' },
  key { 'Quit!', cmd 'q!' },
  key { 'Replace', 'r' },
  key { 'Delete one', [["_x]], details = '(no yank)' },
  key { 'Find', '/' },
  key { 'next match', 'n' },
  key { 'add argument', fn 'actions.treesitter.add_argument' },
  key { 'swapcase', '~' },

  auto_select { 'Substitute', [["_c]] },
  auto_select { 'Command line mode', ':' },
  key { 'execute command', '<cr>', mode = 'c' },
  key { 'literal ;', ';', mode = 'c' },

  key { 'Yank line', 'yy' },
  key { 'copy down', 'Yp' },
  key { 'Unundo', '<C-r>' },
  -- key { "Insert comma at the end", "mzA,<Esc>`z" },
  -- key { "Insert semicolon at the end", "mzA;<Esc>`z" },
  -- key { "Delete comma or semicolon at the end", "mz$x`z" },
  key { 'Join/Merge lines (pretty)', 'mzJ`z' },
  key { 'Join/Merge lines (raw)', 'mzgJ`z' },
  key { 'Insert mode', fn 'actions.insert_mode_indent_blankline', expr = true, details = '(indent blankline)' },
  key {
    'Delete line ',
    fn 'actions.delete_line_no_yank_blankline',
    expr = true,
    details = [[(don't yank blankline)]],
  },
  key { 'indent', '>>' },
  key { 'deindent', '<<' },
  key { 'open Line below', 'o' },
  key { 'open Line above', 'O' },
  key { 'add Line below', 'o<esc>' },
  key { 'add Line above', 'O<esc>' },
  key { 'Toggle macro recording', fn 'actions.toggle_macro_recording' },
  key { 'Repeat macro', '@q' },

  on_selection { 'Yank', 'y`>' },
  on_selection { 'Paste', 'P' },
  on_selection { 'indent', '>gv' },
  on_selection { 'deindent', '<gv' },
  on_selection { 'Uppercase', 'U' },
  on_selection { 'Lowercase', 'u' },
  on_selection { 'Move line down', ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv" },
  on_selection { 'Move line up', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv" },
  on_selection { 'Change visual mode', fn 'actions.change_visual_mode', expr = true },
  on_selection { 'clean', '<Esc>', details = '(exit visual mode)' },

  insert { 'Comma with auto undo breakpoints', ',<C-g>u' },
  insert { 'Semicolon with auto undo breakpoints', ';<C-g>u' },
  insert { 'Dot with auto undo breakpoints', '.<C-g>u' },
  insert { 'escape to normal mode', fn 'actions.treesitter.clean_exit' },
  insert { 'escape to normal mode also', fn 'actions.treesitter.clean_exit' },
  insert { 'escape to normal mode again', fn 'actions.treesitter.clean_exit' },

  -- control
  key { 'Undo jump', '<C-t>' },

  -- alt
  key { 'Move line down', cmd [[execute 'move .+' . v:count1]] .. '==' },
  key { 'Move line up', cmd [[execute 'move .-' . (v:count1 + 1)]] .. '==' },
}

-- Setup numeric keymaps
require('utils.numeric_keymaps').setup()

local mappings_to_disable = {
  x = {
    'u',
    'U',
  },
}

for mode, keys in pairs(mappings_to_disable) do
  for _, key in ipairs(keys) do
    pcall(vim.keymap.del, mode, key)
  end
end
