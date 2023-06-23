local M = {
  -- Find files
  require(User .. ".nav.telescope"),
  require(User .. ".nav.extensions"),
  require(User .. ".nav.rooter"),

  -- Utils
  require(User .. ".nav.harpoon"),
  require(User .. ".nav.trouble"),
  require(User .. ".nav.tmux"),
  {
    "nvim-telescope/telescope-ui-select.nvim",
    lazy = true,
  },
  {
    "AckslD/nvim-neoclip.lua",
    lazy = false,
    opts = {
      keys = {
        telescope = {
          i = {
            edit = false,
          },
        },
      },
    },
  },
  {
    "axieax/urlview.nvim",
    cmd = "UrlView",
    opts = {},
  },
}

if vim.fn.has("wsl") == 1 then
  M[#M].opts = {
    default_action = "wslview",
  }
  table.insert(M[1].dependencies, {
    "nvim-telescope/telescope-fzf-native.nvim",
    build =
    "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
  })
else
  table.insert(M[1].dependencies, {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  })
end

return M
