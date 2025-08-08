require 'config.keymaps.reset'
local spec_gen = require 'utils.keymap_spec_generator'
local motion = spec_gen.motion
local edit = spec_gen.edit
local normal = spec_gen.normal
local visual = spec_gen.visual
local insert = spec_gen.insert
local command = spec_gen.command

local utils = require 'utils'
local cmd = utils.cmd
local fn = utils.fn

return {
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
  normal { 'Replace', 'r' },
  normal { 'Delete one', [["_x]], details = '(no yank)' },
  normal { 'Find in document', '/' },
  normal { 'Add argument', fn 'actions.treesitter.add_argument' },

  edit { 'Substitute', [["_c]] },
  edit { 'Command line mode', ':' },

  normal { 'Yank line', 'yy' },
  normal { 'Yank to eol', 'y$' },
  normal { 'Copy down', 'Yp' },
  normal { 'Unundo', '<C-r>' },
  -- normal { "Insert comma at the end", "mzA,<Esc>`z" },
  -- normal { "Insert semicolon at the end", "mzA;<Esc>`z" },
  -- normal { "Delete comma or semicolon at the end", "mz$x`z" },
  normal { 'Join/Merge lines (pretty)', 'mzJ`z' },
  normal { 'Join/Merge lines (raw)', 'mzgJ`z' },
  normal { 'Insert mode', fn 'actions.insert_mode_indent_blankline', expr = true, details = '(indent blankline)' },
  normal {
    'Delete line ',
    fn 'actions.delete_line_no_yank_blankline',
    expr = true,
    details = [[(don't yank blankline)]],
  },
  normal { 'Indent', '>>' },
  normal { 'Deindent', '<<' },
  normal { 'Open Line below', 'o' },
  normal { 'Open Line above', 'O' },
  normal { 'Add Line below', 'o<esc>' },
  normal { 'Add Line above', 'O<esc>' },
  normal { 'Toggle macro recording', fn 'actions.toggle_macro_recording' },
  normal { 'Repeat macro', '@q' },

  visual { 'Yank', 'y`>' },
  visual { 'Paste', 'P' },
  visual { 'Indent', '>gv' },
  visual { 'Deindent', '<gv' },
  visual { 'Uppercase', 'U' },
  visual { 'Lowercase', 'u' },
  visual { 'Move line down', ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv" },
  visual { 'Move line up', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv" },
  visual { 'Change visual mode', fn 'actions.change_visual_mode', expr = true },
  visual { 'Visual mode', '<Esc>', details = '(exit)' },

  insert { 'Escape to normal mode', fn 'actions.treesitter.clean_exit' },
  insert { 'Move line down', '<esc>' .. cmd 'm .+1' .. '==gi' },
  insert { 'Move line up', '<esc>' .. cmd 'm .-2' .. '==gi' },
  insert { 'Comma with auto undo breakpoints', ',<C-g>u' },
  insert { 'Semicolon with auto undo breakpoints', ';<C-g>u' },
  insert { 'Dot with auto undo breakpoints', '.<C-g>u' },

  -- control
  normal { 'Undo jump', '<C-t>' },

  -- alt
  edit { 'Quit', vim.cmd.q },

  -- ?
  normal { 'Move line down', cmd [[execute 'move .+' . v:count1]] .. '==' },
  normal { 'Move line up', cmd [[execute 'move .-' . (v:count1 + 1)]] .. '==' },
  normal { 'To', fn 'actions.to' },
  normal { 'back To', fn 'actions.back_to' },
}
