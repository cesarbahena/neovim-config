return function()
  require("lualine").setup({
    options = {
      theme = "catppuccin",
      component_separators = "",
      section_separators = "",
    },
    sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        require(User .. ".ui.file_info").cwd,
        require(User .. ".ui.file_info").git,
        require(User .. ".ui.file_info").filetype,
        require(User .. ".ui.file_info").filename,
        require(User .. ".ui.file_info").write_status,
      },
      lualine_x = {
        {
          function()
            return Keyboard
          end,
          icon = " ",
        },
        require(User .. ".ui.server_info").linters,
        require(User .. ".ui.server_info").formatters,
        require(User .. ".ui.server_info").lsp,
      },
      lualine_y = {},
      lualine_z = {},
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_y = {},
      lualine_z = {},
      lualine_c = {},
      lualine_x = {},
    },
  })
end
