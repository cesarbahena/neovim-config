require('cmdline')({
  match_fuzzy = true,
  highlight_selection = true,
  selection_hl = "PmenuSel",
  highlight_directories = true,
  directory_hl = "Directory",
  max_col_num = 6,
  min_col_width = 20,
  debounce_ms = 10,
  default_hl = "Pmenu",
  highlight_substr = true,
  substr_hl = "LineNr",
  offset = 1   -- depending on 'cmdheight' you might have to change the height offset
})
