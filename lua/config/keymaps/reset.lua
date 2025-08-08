-- Disable default [ and ] combinations to avoid delay with custom mappings
local mappings_to_disable = {
  '[c', ']c',  -- diff/changes
  '[d', ']d',  -- diagnostics
  '[D', ']D',  -- diagnostics (first/last)  
  '[m', ']m',  -- methods
  '[M', ']M',  -- methods (end)
  '[s', ']s',  -- spelling
  '[S', ']S',  -- spelling (bad words)
  '[{', ']}',  -- brackets
  '[(', '])',  -- parentheses
  '[[', ']]',  -- sections
  '[]', '][',  -- sections (end)
  '[f', ']f',  -- files
  '[t', ']t',  -- tags
  '[T', ']T',  -- tags (previous)
  '[q', ']q',  -- quickfix
  '[Q', ']Q',  -- quickfix (first/last)
  '[l', ']l',  -- location list
  '[L', ']L',  -- location list (first/last)
  '[b', ']b',  -- buffers
  '[B', ']B',  -- buffers (first/last)
  '[a', ']a',  -- args
  '[A', ']A',  -- args (first/last)
  '[e', ']e',  -- errors
  '[w', ']w',  -- warnings
  '[h', ']h',  -- hunks (git)
  '[g', ']g',  -- git changes
  '[p', ']p',  -- paste
  '[P', ']P',  -- paste before
  '[ ', '] ',  -- blank lines
  '[<Tab>', ']<Tab>',  -- indent
  '[<C-L>', ']<C-L>',  -- control-L variants
  '[<C-Q>', ']<C-Q>',  -- control-Q variants
  '[<C-T>', ']<C-T>',  -- control-T variants
}

for _, mapping in ipairs(mappings_to_disable) do
  pcall(vim.keymap.del, 'n', mapping)
end