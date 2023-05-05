User = 'cesar'
Keyboard = 'colemak'

function P(v)
  print(vim.inspect(v))
  return v
end

function Require(dir, files, callable)
  for _, file in ipairs(files) do
    local module = require(dir..'.'..file)
    if callable then
      module()
    end
  end
end

function Switch_to_keyboard(keyboard)
  Keyboard = keyboard
  package.loaded[User..'.keymaps'] = nil
  require(User..'.keymaps')
end

require(User)
