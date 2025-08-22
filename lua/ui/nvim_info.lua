local M = {}

M.global_errors = {
  function()
    if _G.Errors and type(_G.Errors) == 'table' and #_G.Errors > 0 then return ' ' .. tostring(#_G.Errors) end
    return ''
  end,
  color = { fg = '#f38ba8', gui = 'bold' },
  cond = function() return _G.Errors and type(_G.Errors) == 'table' and #_G.Errors > 0 end,
}

return M
