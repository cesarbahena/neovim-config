-- Python-specific keymap overrides
-- Remap ai to use (outer, inner) behavior for better Python indentation

-- keymap {
--   operator {
--     'Indentation with line above',
--     fn('various-textobjs.indentation', 'outer', 'inner'),
--   }
-- }

-- Native API override for Python files
vim.keymap.set({ 'o', 'x' }, 'ai', function()
  require('various-textobjs').indentation('outer', 'inner')
end, { desc = 'Indentation with line above', buffer = true })