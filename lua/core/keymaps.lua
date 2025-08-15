keymap {
  motion { 'Next line', "v:count == 0 ? 'gj' : 'j'", expr = true, silent = true },
  motion { 'next page', '<C-d>zz' },
  motion { 'prEv line', "v:count == 0 ? 'gk' : 'k'", expr = true, silent = true },
  motion { 'prev page', '<C-u>zz' },
  motion { 'prev word', 'b' },
  motion { 'prev w.ord', 'B' },
  motion { 'rest of word', 'e' },
  motion { 'rest of w.ord', 'E' },
  motion { 'next word', 'w' },
  motion { 'next w.ord', 'W' },
  motion { 'move left', 'h' },
  motion { 'hoMe', '^' },
  motion { 'move right', 'l' },
  motion { 'eoL', '$' },
  motion { 'next match', 'n' },
  motion { 'repeat', '.' },
  motion { 'repeat', '.' },
  key { 'Quit!', cmd 'q!' },
  key { 'Replace', 'r' },
  key { 'Delete one', [["_x]], details = '(no yank)' },
  key { 'Find in document', '/' },
  key { 'Add argument', fn 'actions.treesitter.add_argument' },
  key { 'swapcase', '~' },

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
  key { 'indenT', '>>' },
  key { 'Deindent', '<<' },
  key { 'Open Line below', 'o' },
  key { 'Open Line above', 'O' },
  key { 'add Line below', 'o<esc>' },
  key { 'add Line above', 'O<esc>' },
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

  -- insert { 'Escape to normal mode', fn 'actions.treesitter.clean_exit' },
  insert { 'Comma with auto undo breakpoints', ',<C-g>u' },
  insert { 'Semicolon with auto undo breakpoints', ';<C-g>u' },
  insert { 'Dot with auto undo breakpoints', '.<C-g>u' },
  insert { 'enter', '<cr>' },

  -- control
  key { 'Undo jump', '<C-t>' },

  -- alt
  auto_select { 'clean', cmd 'nohl' },
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

-- Set with defer to override plugins

vim.defer_fn(function() 
  vim.keymap.set('i', '<CR>', function()
    -- Try blink-pairs enter first
    local ok, blink_pairs_mappings = pcall(require, 'blink.pairs.mappings')
    if ok and blink_pairs_mappings.is_enabled() then
      local ctx_ok, ctx = pcall(require, 'blink.pairs.context')
      local rule_lib_ok, rule_lib = pcall(require, 'blink.pairs.rule')
      if ctx_ok and rule_lib_ok then
        local context = ctx.new()
        local config_ok, config = pcall(require, 'blink.pairs.config')
        if config_ok then
          local rules = rule_lib.get_all(rule_lib.parse(config.mappings.pairs))
          local rule = rule_lib.get_surrounding(context, rules, 'enter')
          if rule ~= nil then
            return blink_pairs_mappings.enter(rules)()
          end
        end
      end
    end
    -- If no blink-pairs handling, exit insert mode
    return require('actions.treesitter').clean_exit()
  end, { expr = true, silent = true })
end, 100)
