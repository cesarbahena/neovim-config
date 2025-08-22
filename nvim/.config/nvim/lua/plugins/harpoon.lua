return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function() require('harpoon'):setup() end,
  keys = {
    motion { 'Harpoon 1', function() require('harpoon'):list():select(1) end },
    motion { 'Harpoon 2', function() require('harpoon'):list():select(2) end },
    motion { 'Harpoon 3', function() require('harpoon'):list():select(3) end },
    motion { 'Harpoon 4', function() require('harpoon'):list():select(4) end },
    motion {
      'Harpoon menu',
      function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end,
    },
    motion {
      'Harpoon add',
      function() require('harpoon'):list():add() end,
    },
  },
}
