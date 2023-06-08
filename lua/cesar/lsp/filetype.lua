local augroup_format = vim.api.nvim_create_augroup("custom-lsp-format", { clear = true })

local autocmd_format = function(filter)
  vim.api.nvim_clear_autocmds({ buffer = 0, group = augroup_format })
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = 0,
    callback = function()
      vim.lsp.buf.format({ filter = filter })
    end,
  })
end

return {
  lua = function()
    autocmd_format()
  end,

  clojure_lsp = function()
    autocmd_format()
  end,

  ruby = function()
    autocmd_format()
  end,

  go = function()
    autocmd_format()
  end,

  scss = function()
    autocmd_format()
  end,

  css = function()
    autocmd_format()
  end,

  rust = function()
    -- telescope_mapper("<space>wf", "lsp_workspace_symbols", {
    -- 	ignore_filename = true,
    -- 	query = "#",
    -- }, true)
    autocmd_format()
  end,

  racket = function()
    autocmd_format()
  end,

  typescript = function()
    autocmd_format(function(client)
      return client.name ~= "tsserver"
    end)
  end,

  javascript = function()
    autocmd_format(function(client)
      return client.name ~= "tsserver"
    end)
  end,

  python = function()
    autocmd_format()
  end,
}
