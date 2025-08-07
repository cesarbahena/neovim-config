return {
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      semantic = { enable = false },
      diagnostics = {
        globals = {
          "vim",
          "KeyboardLayout",
          "try",
          "keymap", 
          "autocmd",
          "normal",
          "visual", 
          "pending",
          "insert",
          "command",
          "motion",
          "operator", 
          "edit",
          "fn",
          "cmd",
        },
      },
    },
  },
}