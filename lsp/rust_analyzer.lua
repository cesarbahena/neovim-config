return {
  cmd = { "rustup", "run", "rust-analyzer" },
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy",
      },
    },
  },
}