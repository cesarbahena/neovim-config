local VTO = [[<cmd>lua require("various-textobjs").%s<cr>]]

local textobjs = {
  d = {
    desc = 'Function Definition',
    treesitter = true,
    { a = '@function.outer', i = '@function.inner' },
  },
  o = {
    desc = 'Loop',
    treesitter = true,
    { a = '@loop.outer', i = '@loop.inner' },
  },
  y = {
    desc = 'Conditional',
    treesitter = true,
    { a = '@conditional.outer', i = '@conditional.inner' },
  },
  b = {
    desc = 'Block',
    treesitter = true,
    { a = '@block.outer', i = '@block.inner' },
  },
  ['<C-a>'] = {
    desc = 'Number',
    treesitter = true,
    { a = '@number.inner', i = '@number.inner' },
  },
  ['\\'] = {
    desc = 'Regex',
    treesitter = true,
    { a = '@regex.outer', i = '@regex.inner' },
  },
  ['='] = {
    desc = 'Assignment',
    treesitter = true,
    { a = '@assignment.outer', i = '@assignment.inner' },
  },
  k = {
    desc = 'Bracket',
    { { '%b()', '%b[]', '%b{}' }, '^.().*().$' },
  },
  ['/'] = {
    desc = 'Date',
    { '()%d+[/%-]%w+[/%-]%d+()' },
  },
  D = {
    desc = 'Double bracket string',
    { '()%[%[().-()%]%]()' },
  },
  x = {
    desc = 'XML/HTML attribute',
    { ' ()%w+=["{]().-()["}]()' },
  },
  Z = {
    desc = 'Subword',
    {
      {
        '%u[%l%d]+%f[^%l%d]',
        '%f[%S][%l%d]+%f[^%l%d]',
        '%f[%P][%l%d]+%f[^%l%d]',
        '^[%l%d]+%f[^%l%d]',
      },
      '^().*()$',
    },
  },
}

return {
  {
    'echasnovski/mini.ai',
    event = 'VeryLazy',
    opts = function(self)
      local ts = require(self.name).gen_spec.treesitter
      local custom_textobjects = {}

      for key, spec in pairs(textobjs) do
        if not spec[1] then break end

        if spec.treesitter then
          custom_textobjects[key] = ts(spec[1])
        else
          custom_textobjects[key] = spec[1]
        end
      end

      return {
        custom_textobjects = custom_textobjects,
      }
    end,

    keys = function()
      local keys = {}

      for key, spec in pairs(textobjs) do
        table.insert(keys, {
          (']%s'):format(key),
          ('van%s<Esc>'):format(key),
          desc = ('Next %s'):format(spec.desc),
          remap = true,
        })

        table.insert(keys, {
          ('[%s'):format(key),
          ('val%s<Esc>'):format(key),
          desc = ('Previous %s'):format(spec.desc),
          remap = true,
        })
      end

      return keys
    end,
  },

  {
    'chrisgrieser/nvim-various-textobjs',
    dependencies = { 'echasnovski/mini.ai' },
    opts = {},
    keys = {

      { desc = 'Indentation', 'ii', VTO:format [[indentation('inner', 'inner')]], mode = { 'o', 'x' } },
      { desc = 'Indentation', 'igi', VTO:format [[indentation('inner', 'inner')]], mode = { 'o', 'x' } },
      {
        desc = 'Indentation and lines above/below',
        'ai',
        VTO:format [[indentation('outer', 'outer')]],
        mode = { 'o', 'x' },
      },
      { desc = 'Indentation and line above', 'agi', VTO:format [[indentation('outer', 'inner')]], mode = { 'o', 'x' } },
      { desc = 'Rest of indentation', 'iI', VTO:format [[restOfIndentation()]], mode = { 'o', 'x' } },
      { desc = 'Greedy outer indentation', 'aI', VTO:format [[outerIndentation 'inner']], mode = { 'o', 'x' } },
      {
        desc = 'Subword',
        'iz',
        function()
          vim.print 'Hello'
          return VTO:format [[subword 'inner']]
        end,
        expr = true,
        mode = { 'o', 'x' },
      },
      { desc = 'Subword and hyphens', 'az', VTO:format [[subword 'outer']], mode = { 'o', 'x' } },

      {
        desc = 'Next Subword',
        'z',
        function() require('mini.ai').move_cursor('left', 'i', 'Z', { search_method = 'next' }) end,
        mode = { 'n', 'x', 'o' },
      },
      {
        desc = 'Next Subword',
        'Z',
        function() require('mini.ai').move_cursor('left', 'i', 'Z', { search_method = 'prev' }) end,
        mode = { 'n', 'x', 'o' },
      },

      { desc = 'To next closing bracket', 'iK', VTO:format [[toNextClosingBracket()]], mode = { 'o', 'x' } },
      { desc = 'To next closing bracket', 'aK', VTO:format [[toNextClosingBracket()]], mode = { 'o', 'x' } },
      { desc = 'Near EoL', ',', VTO:format 'nearEoL()', mode = { 'o', 'x' } },
      { desc = 'To next quotation mark', 'iQ', VTO:format [[toNextQuotationMark()]], mode = { 'o', 'x' } },
      { desc = 'To next quotation mark', 'aQ', VTO:format [[toNextQuotationMark()]], mode = { 'o', 'x' } },
      { desc = 'Rest of paragraph', 'iP', VTO:format [[restOfParagraph()]], mode = { 'o', 'x' } },
      { desc = 'Rest of paragraph', 'aP', VTO:format [[restOfParagraph()]], mode = { 'o', 'x' } },
      { desc = 'Entire buffer', 'gG', VTO:format [[entireBuffer()]], mode = { 'o', 'x' } },
      { desc = 'Near EoL', ',', VTO:format 'nearEoL()', mode = { 'o', 'x' } },
      { desc = 'Line characterwise', 'i_', VTO:format [[lineCharacterwise 'inner']], mode = { 'o', 'x' } },
      {
        desc = 'Line characterwise with indentation and trailing space',
        'a_',
        VTO:format [[lineCharacterwise 'outer']],
        mode = { 'o', 'x' },
      },
      { desc = 'Rest of column', 'i<c-v>', VTO:format [[column('down')]], mode = { 'o', 'x' } },
      { desc = 'Column', 'a<c-v>', VTO:format [[column('both')]], mode = { 'o', 'x' } },
      { desc = 'Value', 'iv', VTO:format [[value 'inner']], mode = { 'o', 'x' } },
      { desc = 'Value and trailing comma or semicolon', 'av', VTO:format [[value 'outer']], mode = { 'o', 'x' } },
      { desc = 'Variable', 'iV', VTO:format [[key 'inner']], mode = { 'o', 'x' } },
      { desc = 'Variable and operator)', 'aV', VTO:format [[key 'outer']], mode = { 'o', 'x' } },
      { desc = 'URL', 'L', VTO:format [[url()]], mode = { 'o', 'x' } },
      { desc = 'Diagnostic', '!', VTO:format [[diagnostic()]], mode = { 'o', 'x' } },
      -- { desc = "Closed fold", "iz", VTO:format[[closedFold 'inner']], mode = { 'o', 'x' } },
      -- { desc = "Closed fold and blank line", "az", VTO:format[[closedFold 'outer']], mode = { 'o', 'x' } },
      { desc = 'Chain member', 'im', VTO:format [[chainMember 'inner']], mode = { 'o', 'x' } },
      { desc = 'Dot/colon and chain Member', 'am', VTO:format [[chainMember 'outer']], mode = { 'o', 'x' } },
      { desc = 'Visible in window', 'gw', VTO:format [[visibleInWindow()]], mode = { 'o', 'x' } },
      { desc = 'Rest of window', 'gW', VTO:format [[restOfWindow()]], mode = { 'o', 'x' } },
      { desc = 'Last change', 'ie', VTO:format [[lastChange()]], mode = { 'o', 'x' } },
      { desc = 'Last change', 'ae', VTO:format [[lastChange()]], mode = { 'o', 'x' } },
      { desc = 'Emoji', '.', VTO:format [[emoji()]], mode = { 'o', 'x' } },
      { desc = 'Natural number', 'i<c-a>', VTO:format [[number 'inner']], mode = { 'o', 'x' } },
      { desc = 'Real number', 'a<c-a>', VTO:format [[number 'outer']], mode = { 'o', 'x' } },
      { desc = 'Filepath', 'iF', VTO:format [[filepath 'inner']], mode = { 'o', 'x' } },
      { desc = 'Filepath', 'aF', VTO:format [[filepath 'outer']], mode = { 'o', 'x' } },
      { desc = 'Color (value only)', 'i#', VTO:format [[color 'inner']], mode = { 'o', 'x' } },
      { desc = 'Color', 'a#', VTO:format [[color 'outer']], mode = { 'o', 'x' } },
      { desc = 'CSS selector', 'iS', VTO:format [[cssSelector 'inner']], mode = { 'o', 'x' } },
      {
        desc = 'CSS selector with trailing comma and space',
        'aS',
        VTO:format [[cssSelector 'outer']],
        mode = { 'o', 'x' },
      },
      { desc = 'Program after pipe', 'i|', VTO:format [[shellPipe 'inner']], mode = { 'o', 'x' } },
      { desc = 'Pipe and program', 'a|', VTO:format [[shellPipe 'outer']], mode = { 'o', 'x' } },

      {
        desc = 'Delete Surrounding Indentation',
        'rdi',
        function()
          require('various-textobjs').indentation('outer', 'outer')
          -- plugin only switches to visual mode when textobj found
          local notOnIndentedLine = vim.fn.mode():find 'V' == nil
          if notOnIndentedLine then return end
          -- dedent indentation
          vim.cmd.normal { '>', bang = true }
          -- delete surrounding lines
          local endBorderLn = vim.api.nvim_buf_get_mark(0, '>')[1] + 1
          local startBorderLn = vim.api.nvim_buf_get_mark(0, '<')[1] - 1
          vim.cmd(tostring(endBorderLn) .. ' delete') -- delete end first so line index is not shifted
          vim.cmd(tostring(startBorderLn) .. ' delete')
        end,
      },

      {
        'ryi',
        function()
          local startPos = vim.api.nvim_win_get_cursor(0)

          -- identify start- and end-border
          require('various-textobjs').indentation('outer', 'outer')
          local indentationFound = vim.fn.mode():find 'V'
          if not indentationFound then return end
          vim.cmd.normal { 'V', bang = true }

          -- copy them into the + register
          local startLn = vim.api.nvim_buf_get_mark(0, '<')[1] - 1
          local endLn = vim.api.nvim_buf_get_mark(0, '>')[1] - 1
          local startLine = vim.api.nvim_buf_get_lines(0, startLn, startLn + 1, false)[1]
          local endLine = vim.api.nvim_buf_get_lines(0, endLn, endLn + 1, false)[1]
          vim.fn.setreg([["]], startLine .. '\n' .. endLine .. '\n')

          -- highlight yanked text
          local dur = 500
          local ns = vim.api.nvim_create_namespace 'ysi'
          local bufnr = vim.api.nvim_get_current_buf()
          vim.hl.range(bufnr, ns, 'IncSearch', { startLn, 0 }, { startLn, -1 }, { timeout = dur })
          vim.hl.range(bufnr, ns, 'IncSearch', { endLn, 0 }, { endLn, -1 }, { timeout = dur })

          -- restore cursor position
          vim.api.nvim_win_set_cursor(0, startPos)
        end,
        desc = 'Yank surrounding indentation',
      },

      {
        '<leader>ryi',
        function()
          local startPos = vim.api.nvim_win_get_cursor(0)

          -- identify start- and end-border
          require('various-textobjs').indentation('outer', 'outer')
          local indentationFound = vim.fn.mode():find 'V'
          if not indentationFound then return end
          vim.cmd.normal { 'V', bang = true }

          -- copy them into the + register
          local startLn = vim.api.nvim_buf_get_mark(0, '<')[1] - 1
          local endLn = vim.api.nvim_buf_get_mark(0, '>')[1] - 1
          local startLine = vim.api.nvim_buf_get_lines(0, startLn, startLn + 1, false)[1]
          local endLine = vim.api.nvim_buf_get_lines(0, endLn, endLn + 1, false)[1]
          vim.fn.setreg('+', startLine .. '\n' .. endLine .. '\n')

          -- highlight yanked text
          local dur = 500
          local ns = vim.api.nvim_create_namespace 'ysi'
          local bufnr = vim.api.nvim_get_current_buf()
          vim.hl.range(bufnr, ns, 'IncSearch', { startLn, 0 }, { startLn, -1 }, { timeout = dur })
          vim.hl.range(bufnr, ns, 'IncSearch', { endLn, 0 }, { endLn, -1 }, { timeout = dur })

          -- restore cursor position
          vim.api.nvim_win_set_cursor(0, startPos)
        end,
        desc = 'Yank surrounding indentation to clipboard',
      },
    },
  },
}
