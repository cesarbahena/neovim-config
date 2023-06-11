local M = {}

function get_source(index)
	return require("null-ls.sources").get_available(vim.bo.ft)[index]
end

local function is_executable(index)
	return require("null-ls.utils").is_executable(get_source(index).name)
end

local icons = {
	eslint = "󰱺",
	prettier = "",
	stylua = "",
}

AutoFormatted = false

for i = 1, 3, 1 do
	M["non_lsp_" .. i] = {
		function()
			local icon = icons[get_source(i).name]
			if icon then
				return icon .. "  " .. get_source(i).name
			end
			return get_source(i).name
		end,

		cond = function()
			return get_source(i) ~= nil
		end,

		color = function()
			local source = get_source(i)
			if not source then
				return
			end

			if source.methods.NULL_LS_FORMATTING and AutoFormatted then
				return "StatuslineOk"
			end

			if source.can_run then
				if source.can_run() then
					return "StatuslineNormal"
				else
					return "StatuslineError"
				end
			end

			if is_executable(i) then
				return "StatuslineNormal"
			end

			local opts = source.generator.opts or {}
			if opts.only_local or opts.prefer_local then
				return "StatuslineNormal"
			end

			return "StatuslineError"
		end,
	}
end

for i = 1, 5, 1 do
	M["lsp_" .. i] = {
		function()
			return vim.lsp.get_active_clients()[i].name
		end,

		cond = function()
			local server = vim.lsp.get_active_clients()[i]
			if not server then
				return
			end

			if server.name == "null-ls" then
				return
			end

			local buffer = vim.api.nvim_get_current_buf()
			return server.attached_buffers[buffer]
		end,

		color = "StatuslineNormal",
		icon = " ",
	}
end

M.no_lsp = {
	function()
		local servers = vim.lsp.get_active_clients()
		if #servers > 5 then
			return "..."
		end

		local buffer = vim.api.nvim_get_current_buf()
		for _, server in ipairs(servers) do
			if server.attached_buffers[buffer] then
				return ""
			end
		end

		return "No LSP"
	end,

	cond = function()
		if vim.bo.ft == "" then
			return
		end

		local exclude = {
			netrw = true,
			TelescopePrompt = true,
			fugitive = true,
			harpoon = true,
			lspinfo = true,
			["null-ls-info"] = true,
		}
		return not exclude[vim.bo.ft]
	end,

	icon = " ",
	color = "StatuslineError",
}

return M
