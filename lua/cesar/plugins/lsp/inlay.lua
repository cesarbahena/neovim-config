return {
  'simrat39/inlay-hints.nvim',
  opts = {
    renderer = "inlay-hints/render/eol",
    hints = {
      parameter = {
        show = true,
        highlight = "whitespace",
      },
      type = {
        show = true,
        highlight = "Whitespace",
      },
    },
    only_current_line = false,
    eol = {
      right_align = false,
      right_align_padding = 7,
      parameter = {
        separator = ", ",
        format = function(hints)
          return string.format(" <- (%s)", hints)
        end,
      },
      type = {
        separator = ", ",
        format = function(hints)
          return string.format(" => %s", hints)
        end,
      },
    },
  },
  config = function (_, opts)
    require 'inlay-hints'.setup(opts)
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("my-inlay-hints", {}),
      callback = function(args)
        local ft = vim.bo[args.buf].filetype
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        require("inlay-hints").on_attach(client, args.buf)
      end
    })
  end
}
