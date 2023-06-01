local autocmd = require(User .. ".config.autocmd")
local telescope = require(User .. ".nav.pickers")

return function(client, bufnr)
	if client.name == "copilot" then
		return
	end

	-- nmap({ "<space>lr", "<cmd>lua require('cesar.plugins.lsp.codelens').run()<CR>" })
	-- telescope_mapper("<space>wd", "lsp_document_symbols", { ignore_filename = true }, true)
	-- telescope_mapper("<space>ww", "lsp_dynamic_workspace_symbols", { ignore_filename = true }, true)
	Keymap({
		[""] = {
			{ "Go to definition", "gd", vim.lsp.buf.definition },
			{ "Go to declaration", "gD", vim.lsp.buf.declaration },
			{ "Go to type definition", "gT", vim.lsp.buf.type_definition },
			{ "Go to references", "gr", telescope("lsp_references", "wide") },
			{ "Go to implementations", "gI", telescope("lsp_implementations", "wide") },
			{ "Find docunment symbols", "<leader>fs", telescope("lsp_document_symbols", "wide") },
			{ "Find docunment symbols", "<leader>fd", telescope("lsp_dynamic_workspace_symbols", "wide") },
			{ "Code rename", "<leader>cr", vim.lsp.buf.rename },
			{ "Code actions", "<leader>ca", vim.lsp.buf.code_action },
			{ "Show hover help", "<C-s>", vim.lsp.buf.hover },
		},
		i = {
			{ "Show signature help", "<C-s>", vim.lsp.buf.signature_help },
		},
	}, { buffer = true })

	vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

	-- Set autocommands conditional on server_capabilities
	if client.server_capabilities.documentHighlightProvider then
		autocmd({
			"CursorHold",
			"CustomLspReferences",
			vim.lsp.buf.document_highlight,
			bufnr,
			clear = true,
		})
		autocmd({
			"CursorMoved",
			"CustomLspReferences",
			vim.lsp.buf.clear_references,
			bufnr,
			-- clear = true,
		})
	end

	-- if client.server_capabilities.codeLensProvider then
	-- 	autocmd_clear({ group = augroup_codelens, buffer = bufnr })
	-- 	autocmd({ "BufEnter", augroup_codelens, vim.lsp.codelens.refresh, bufnr, once = true })
	-- 	autocmd({ { "BufWritePost", "CursorHold" }, augroup_codelens, vim.lsp.codelens.refresh, bufnr })
	-- end

	-- if vim.bo.ft == "typescript" then
	-- 	client.server_capabilities.semanticTokensProvider = nil
	-- end

	-- Attach any filetype specific options to the client
	require(User .. ".lsp.filetype")[vim.bo.ft]()
	vim.notify(vim.bo.ft)
end
