local M = {}

M.linters = {
	function()
		local get_services = function(filetype, service_type)
			return require("null-ls.sources").get_available(filetype, service_type)
		end
		local formatters = get_services(vim.bo.ft, "NULL_LS_DIAGNOSTICS")
		local output = ""
		for i, _ in ipairs(formatters) do
			pcall(function()
				output = output .. " " .. formatters[i].name
			end)
		end
		return output
	end,
}

M.formatters = {
	function()
		local get_services = function(filetype, service_type)
			return require("null-ls.sources").get_available(filetype, service_type)
		end
		local formatters = get_services(vim.bo.ft, "NULL_LS_FORMATTING")
		local output = ""
		for i, _ in ipairs(formatters) do
			pcall(function()
				output = output .. " " .. formatters[i].name
			end)
		end
		return output
	end,
}

M.lsp = {
	function()
		local msg = "No LSP"
		local clients = vim.lsp.get_active_clients()
		if next(clients) == nil then
			return msg
		end
		for _, client in ipairs(clients) do
			local filetypes = client.config.filetypes
			if filetypes and vim.fn.index(filetypes, vim.bo.ft) ~= -1 then
				return client.name
			end
		end
		return msg
	end,
	icon = " ",
}

return M
