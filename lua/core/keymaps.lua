keymap {
  motion { 'Next line', "v:count == 0 ? 'gj' : 'j'", expr = true, silent = true },
  motion { 'Next page', '<C-d>zz' },
  motion { 'prEv line', "v:count == 0 ? 'gk' : 'k'", expr = true, silent = true },
  motion { 'prEv page', '<C-u>zz' },
  motion { 'bacK word', 'b' },
  motion { 'bacK w.ord', 'B' },
  motion { 'rest of word', 'e' },
  motion { 'rest of w.ord', 'E' },
  motion { 'Hop to next word', 'w' },
  motion { 'Hop to next w.ord', 'W' },
  motion { 'Move left', 'h' },
  motion { 'hoMe', '^' },
  motion { 'Move right', 'l' },
  motion { 'eoL', '$' },
  motion { 'Next match', 'n' },
  key { 'Quit!', cmd 'q!' },
  key { 'Replace', 'r' },
  key { 'Delete one', [["_x]], details = '(no yank)' },
  key { 'Find in document', '/' },
  key { 'Add argument', fn 'actions.treesitter.add_argument' },

  auto_select { 'Substitute', [["_c]] },
  auto_select { 'Command line mode', ':' },

  key { 'Yank line', 'yy' },
  key { 'Yank to eol', 'y$' },
  key { 'Copy down', 'Yp' },
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
  key { 'Indent', '>>' },
  key { 'Deindent', '<<' },
  key { 'Open Line below', 'o' },
  key { 'Open Line above', 'O' },
  key { 'Add Line below', 'o<esc>' },
  key { 'Add Line above', 'O<esc>' },
  key { 'Toggle macro recording', fn 'actions.toggle_macro_recording' },
  key { 'Repeat macro', '@q' },

  on_selection { 'Yank', 'y`>' },
  on_selection { 'Paste', 'P' },
  on_selection { 'Indent', '>gv' },
  on_selection { 'Deindent', '<gv' },
  on_selection { 'Uppercase', 'U' },
  on_selection { 'Lowercase', 'u' },
  on_selection { 'Move line down', ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv" },
  on_selection { 'Move line up', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv" },
  on_selection { 'Change visual mode', fn 'actions.change_visual_mode', expr = true },
  on_selection { 'Visual mode', '<Esc>', details = '(exit)' },

  insert { 'Escape to normal mode', fn 'actions.treesitter.clean_exit' },
  insert { 'Move line down', '<esc>' .. cmd 'm .+1' .. '==gi' },
  insert { 'Move line up', '<esc>' .. cmd 'm .-2' .. '==gi' },
  insert { 'Comma with auto undo breakpoints', ',<C-g>u' },
  insert { 'Semicolon with auto undo breakpoints', ';<C-g>u' },
  insert { 'Dot with auto undo breakpoints', '.<C-g>u' },

  -- control
  key { 'Undo jump', '<C-t>' },

  -- alt
  auto_select { 'Quit', vim.cmd.q },
  key { 'Move line down', cmd [[execute 'move .+' . v:count1]] .. '==' },
  key { 'Move line up', cmd [[execute 'move .-' . (v:count1 + 1)]] .. '==' },
}

-- Setup numeric keymaps
require('utils.numeric_keymaps').setup()

local mappings_to_disable = {}

for mode, keys in pairs(mappings_to_disable) do
  for _, key in ipairs(keys) do
    pcall(vim.keymap.del, mode, key)
  end
end
