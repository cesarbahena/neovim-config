function P(v)
  print(vim.inspect(v))
  return v
end

function Plugin(module_name)
  -- Requires a module from lua.<user>.plugins.
  return require(User .. '.plugins.' .. module_name)
end

function Switch_to_keyboard(keyboard)
  Keyboard = keyboard
  package.loaded[User .. '.mappings'] = nil
  require(User .. '.mappings')
end

