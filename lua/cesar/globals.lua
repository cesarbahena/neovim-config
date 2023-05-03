P = function(v)
  print(vim.inspect(v))
  return v
end

function Copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end

function Switch_to_keyboard(keyboard)
  Keyboard = keyboard
  package.loaded[User..'.keymaps'] = nil
  require(User..'.keymaps')
end
