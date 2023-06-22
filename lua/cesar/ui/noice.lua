return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        command_palette = true,
        lsp_doc_border = true,
      },
      routes = {
        {
          view = "notify",
          filter = {
            event = "msg_show",
            find = "No write since last change",
          },
          opts = { skip = true },
        },
        {
          view = "notify",
          filter = {
            event = "msg_show",
            find = "nvim_win_call",
          },
          opts = { skip = true },
        },
        {
          view = "notify",
          filter = {
            event = "msg_show",
            find = "ModeChanged Autocommands",
          },
          opts = { skip = true },
        },
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      {
        "rcarriga/nvim-notify",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
          require("notify").setup({ background_colour = "#000000" })
          require("telescope").load_extension("notify")

          require(User .. ".config.keymaps")({
            [""] = {
              { "Dismiss", "<leader>e", require("notify").dismiss },
            },
          })
        end,
      },
    },
  },
}
