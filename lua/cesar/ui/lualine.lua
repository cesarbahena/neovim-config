vim.api.nvim_set_hl(0, "StatuslineNormal", { fg = "white", bold = true })
vim.api.nvim_set_hl(0, "StatuslineOk", { fg = "LightGreen", bold = true })
vim.api.nvim_set_hl(0, "StatuslineOkFocus", { fg = "black", bg = "LightGreen", bold = true })
vim.api.nvim_set_hl(0, "StatuslineError", { fg = "#f38ba8", bold = true })
vim.api.nvim_set_hl(0, "StatuslineWarn", { fg = "#f9e2af", bold = true })

return function()
  require("lualine").setup({
    options = {
      component_separators = "",
      section_separators = "",
      disabled_filetypes = {
        winbar = { "dap-repl" },
      },
    },
    sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        require(User .. ".ui.file_info").cwd,
        require(User .. ".ui.file_info").git,
      },
      lualine_x = {
        require(User .. ".ui.server_info").non_lsp_1,
        require(User .. ".ui.server_info").non_lsp_2,
        require(User .. ".ui.server_info").non_lsp_3,
        require(User .. ".ui.server_info").lsp_1,
        require(User .. ".ui.server_info").lsp_2,
        require(User .. ".ui.server_info").lsp_3,
        require(User .. ".ui.server_info").lsp_4,
        require(User .. ".ui.server_info").lsp_5,
        require(User .. ".ui.server_info").no_lsp,
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

    winbar = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        require(User .. ".ui.file_info").filetype,
        require(User .. ".ui.file_info").filename,
        require(User .. ".ui.file_info").unsaved,
      },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
    inactive_winbar = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        require(User .. ".ui.file_info").filetype,
        require(User .. ".ui.file_info").filename,
        require(User .. ".ui.file_info").unsaved,
      },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
  })
end
