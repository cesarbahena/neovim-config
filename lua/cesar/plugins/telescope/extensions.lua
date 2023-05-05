return function()
  require 'telescope'.setup {
    extensions = {

    },
  }
  require('telescope').load_extension('fzf')
  require('telescope').load_extension('neoclip')
  require('telescope').load_extension('notify')
end
