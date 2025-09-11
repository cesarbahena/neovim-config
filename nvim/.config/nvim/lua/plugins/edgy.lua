return {
  'folke/edgy.nvim',
  event = 'VeryLazy',
  init = function()
    vim.opt.laststatus = 3
    vim.opt.splitkeep = 'screen'
  end,
  opts = {
    -- Window options
    options = {
      left = { size = 30 },
      bottom = { size = 10 },
      right = { size = 30 },
      top = { size = 10 },
    },
    
    -- Bottom panel configuration
    bottom = {
      {
        ft = 'toggleterm',
        size = { height = 0.4 },
        filter = function(buf, win)
          return vim.api.nvim_win_get_config(win).relative == ''
        end,
      },
      {
        ft = 'Trouble',
        title = 'DIAGNOSTICS',
        size = { height = 0.3 },
      },
      {
        ft = 'qf',
        title = 'QUICKFIX',
        size = { height = 0.3 },
      },
      {
        ft = 'help',
        size = { height = 20 },
        -- only show help buffers
        filter = function(buf)
          return vim.bo[buf].buftype == 'help'
        end,
      },
      { ft = 'spectre_panel', size = { height = 0.4 } },
      { title = 'Neotest Output', ft = 'neotest-output-panel', size = { height = 15 } },
    },
    
    -- Left panel configuration  
    left = {
      -- Neo-tree filesystem always takes half the screen height
      {
        title = 'FILES',
        ft = 'neo-tree',
        filter = function(buf)
          return vim.b[buf].neo_tree_source == 'filesystem'
        end,
        size = { height = 0.5 },
      },
      {
        title = 'GIT',
        ft = 'neo-tree',
        filter = function(buf)
          return vim.b[buf].neo_tree_source == 'git_status'
        end,
        pinned = true,
        collapsed = true, -- show window as closed/collapsed on start
        open = 'Neotree position=left git_status',
      },
      {
        title = 'BUFFERS', 
        ft = 'neo-tree',
        filter = function(buf)
          return vim.b[buf].neo_tree_source == 'buffers'
        end,
        pinned = true,
        collapsed = true, -- show window as closed/collapsed on start
        open = 'Neotree position=left buffers',
      },
      -- Any other neo-tree windows
      'neo-tree',
    },
    
    -- Right panel configuration
    right = {
      {
        title = 'OUTLINE',
        ft = 'Outline',
        pinned = true,
        open = 'Outline',
      },
    },
    
    -- Top panel configuration  
    top = {
      {
        ft = 'noice',
        size = { height = 0.4 },
        filter = function(buf, win)
          return vim.api.nvim_win_get_config(win).relative == ''
        end,
      },
    },
    
    -- Styling options
    animate = {
      enabled = true,
      fps = 100, -- frames per second
      cps = 120, -- cells per second
      on_begin = function()
        vim.g.minianimate_disable = true
      end,
      on_end = function()
        vim.g.minianimate_disable = false
      end,
      -- Spinner for pinned views that are loading.
      -- if you have noice.nvim installed, you can use any spinner from it, like:
      -- spinner = require("noice.util.spinners").spinners.circleFull,
      spinner = {
        frames = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
        interval = 80,
      },
    },
    
    -- Window appearance
    wo = {
      -- Setting to `true`, will add an edgy winbar.
      winbar = true,
      winhighlight = 'WinBar:EdgyWinBar,Normal:EdgyNormal',
      spell = false,
      signcolumn = 'no',
    },
    
    -- Buffer-local keymaps to be added to edgy buffers.
    -- Existing buffer-local keymaps will never be overridden.
    keys = {
      -- increase width
      ['<c-Right>'] = function(win) win:resize('width', 2) end,
      -- decrease width  
      ['<c-Left>'] = function(win) win:resize('width', -2) end,
      -- increase height
      ['<c-Up>'] = function(win) win:resize('height', 2) end,
      -- decrease height
      ['<c-Down>'] = function(win) win:resize('height', -2) end,
    },
  },
}