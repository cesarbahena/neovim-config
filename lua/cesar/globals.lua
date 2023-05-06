function P(v)
  print(vim.inspect(v))
  return v
end

function Switch_to_keyboard(keyboard)
  vim.g.keyboard = keyboard
  package.loaded[vim.g.user..'.keymaps'] = nil
  require(vim.g.user..'.keymaps')
end
