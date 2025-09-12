return {
  'luukvbaal/statuscol.nvim',
  config = function()
    local builtin = require('statuscol.builtin')
    require('statuscol').setup {
      setopt = true,
      segments = {
        { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
        { sign = { namespace = { 'diagnostic*' } }, maxwidth = 1, auto = true },
        { sign = { name = { 'GitSigns*' } }, maxwidth = 1, auto = true },
        {
          text = { 
            function(args)
              if args.relnum == 0 then
                local has_errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }) > 0
                
                -- Choose color based on errors
                local hl_group = has_errors and 'ErrorMsg' or 'CursorLineNr'
                
                return '%#' .. hl_group .. '# ❯%*'
              else
                return tostring(args.relnum)
              end
            end
          },
          condition = { true },
        },
        { text = { ' ' } },
      },
    }
  end,
}