return function()
  require 'telescope'.setup {
    extensions = {
      dap = {
        theme = 'dropdown',
      },
    },
  }
  require('telescope').load_extension('fzf')
  require('telescope').load_extension('neoclip')
  require('telescope').load_extension('notify')
  require 'telescope'.load_extension 'dap'
end
