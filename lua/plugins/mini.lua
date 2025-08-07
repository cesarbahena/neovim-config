return {
  {
    'echasnovski/mini.pairs',
    event = 'VeryLazy',
    opts = {
      modes = { insert = true, command = true, terminal = false },
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      skip_unbalanced = true,
    },
  },
  {
    'numToStr/Comment.nvim',
    event = 'VeryLazy',
    opts = {
      toggler = { line = 'C', block = 'gC' },
      opleader = { line = 'c', block = 'gc' },
      extra = { above = 'cL', below = 'cl', eol = 'cc' },
      mappings = { basic = true, extra = true },
    },
  },
  {
    'echasnovski/mini.surround',
    opts = {
      respect_selection_type = false,
      silent = true,
      mappings = {
        add = 'r',
        delete = 'rd',
        find = 'rc',
        find_left = 'rp',
        highlight = 'rv',
        replace = 'rs',
        suffix_last = 'e',
        update_n_lines = 'r+',
      },
      custom_surroundings = {
        k = {
          input = {
            { '%b()', '%b[]', '%b{}', '%b<>' },
            '^.().*().$',
          },
          output = { left = '(', right = ')' },
        },
        K = {
          input = {
            { '%b{}', '%b[]', '%b()', '%b<>' },
            '^.().*().$',
          },
          output = { left = '{ ', right = ' }' },
        },
        q = {
          output = { left = "'", right = "'" },
        },
        Q = {
          input = {
            { [[%b'']], [[%b""]], [[%b""]] },
            '^.().*().$',
          },
          output = { left = [["]], right = [["]] },
        },
        D = {
          input = { '%[%[().-()%]%]', '^..().*()..$' },
          output = { left = '[[', right = ']]' },
        },
        ['$'] = {
          input = { '%$%{().-()%}', '^..().*()..$' },
          output = { left = '${', right = '}' },
        },
      },
    },
  },
}
