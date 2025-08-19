return {
  cmd = { 'intelephense', '--stdio' },
  filetypes = { 'php' },
  settings = {
    intelephense = {
      files = {
        maxSize = 1000000,
      },
      format = {
        enable = true,
      },
      diagnostics = {
        enable = true,
      },
    },
  },
}