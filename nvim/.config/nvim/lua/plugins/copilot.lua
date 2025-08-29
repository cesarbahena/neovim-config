return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      hide_during_completion = true,
      keymap = {
        accept = '<c-u>',
      },
    },
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main',
    cmd = 'CopilotChat',
    opts = function()
      local user = vim.env.USER or 'User'
      user = user:sub(1, 1):upper() .. user:sub(2)
      return {
        auto_insert_mode = true,
        question_header = '  ' .. user .. ' ',
        answer_header = '  Copilot ',
        window = {
          width = 0.3,
        },
      }
    end,
    keys = {
      { '<c-u>', '<cr>', ft = 'copilot-chat', desc = 'Submit Prompt', remap = true, mode = 'n' },
      { '<c-u>', '<c-o><cr>', ft = 'copilot-chat', desc = 'Submit Prompt', remap = true, mode = 'i' },
      {
        '?',
        desc = 'Toggle (CopilotChat)',
        function()
          local copilot_win = vim.fn.bufwinid 'CopilotChat'
          if copilot_win == -1 then
            vim.cmd 'CopilotChatOpen'
          else
            vim.api.nvim_set_current_win(copilot_win)
          end
        end,
        mode = { 'n', 'v' },
      },
      {
        'cS',
        desc = 'Prompt Actions (CopilotChat)',
        fn 'CopilotChat.select_prompt',
        mode = { 'n', 'v' },
      },
    },
    config = function(_, opts)
      require('CopilotChat').setup(opts)

      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = 'copilot-chat',
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })
    end,
  },
}
