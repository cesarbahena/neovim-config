-- Jump directly to the first available definition every time.
vim.lsp.handlers["textDocument/definition"] = function(_, result)
	if not result or vim.tbl_isempty(result) then
		print("[LSP] Could not find definition")
		return
	end

	if vim.tbl_islist(result) then
		vim.lsp.util.jump_to_location(result[1], "utf-8")
	else
		vim.lsp.util.jump_to_location(result, "utf-8")
	end
end

vim.lsp.handlers["textDocument/publishDiagnostics"] =
	vim.lsp.with(vim.lsp.handlers["textDocument/publishDiagnostics"], {
		signs = {
			severity_limit = "Error",
		},
		underline = {
			severity_limit = "Warning",
		},
		virtual_text = true,
	})

vim.lsp.handlers["window/showMessage"] = require(User .. ".lsp.show_message")
