local autocmd = require(User .. ".config.autocmd")

local autocmd_format = function(filter)
	autocmd({
		"BufWritePre",
		"CustomLspFormat",
		function()
			vim.lsp.buf.format({ filter = filter })
			AutoFormatted = true
			vim.defer_fn(function()
				AutoFormatted = false
			end, 5000)
		end,
		buffer = 0,
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
