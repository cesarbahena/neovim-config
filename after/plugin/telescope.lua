local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>m', builtin.find_files, {})
vim.keymap.set('n', '<leader>f', builtin.git_files, {})
vim.keymap.set('n', '<leader>g', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
