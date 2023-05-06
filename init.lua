vim.g.user = 'cesar'
vim.g.keyboard = 'colemak'

require(vim.g.user)

-- print(
-- vim.inspect({
--   {
--     'nvim-telescope/telescope.nvim',
--     branch = '0.1.1',
--     lazy = false,
--     dependencies = { 'nvim-lua/plenary.nvim' },
--     keys = {
--       { '<leader>fp', '<cmd>Telescope find_files<CR>' },
--     },
--     opts = {
--       require(User .. '.plugins.telescope.options')
--     },
--     config = function(_, opts)
--       require'telescope'.setup(opts)
--       require(User .. '.plugins.telescope.mappings')()
--     end,
--   },
-- })
-- )
