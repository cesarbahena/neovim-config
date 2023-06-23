local M = {}

local function get_source(index)
	return require("null-ls.sources").get_available(vim.bo.ft)[index]
end

local function is_executable(index)
	return require("null-ls.utils").is_executable(get_source(index).name)
end

local nls_icons = {
	eslint = "󰱺",
	prettier = "󰏣",
	stylua = "",
}

AutoFormatted = false

for i = 1, 3, 1 do
	M["nls_" .. i] = {
		function()
			local icon = nls_icons[get_source(i).name]
			if icon then
				return icon .. "  " .. get_source(i).name
			end
			return " " .. get_source(i).name
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

local devicons_available, devicons = pcall(require, "nvim-web-devicons")
local get_icon = devicons.get_icon_by_filetype
local lsp_icons = {}
if devicons_available then
	local servers = {
		lua_ls = "lua",
		emmet_ls = "xml",
		tsserver = "typescript",
		html = "html",
		cssls = "css",
		pyright = "python",
	}
	for server, filetype in pairs(servers) do
		lsp_icons[server] = get_icon(filetype)
	end
end

for i = 1, 5, 1 do
	M["lsp_" .. i] = {
		function()
			local server = vim.lsp.get_active_clients()[i]
			local icon = lsp_icons[server.name]
			if icon then
				return icon .. "  " .. server.name
			end
			return "  " .. server.name
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
	}
end

M.lsp_error = {
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
			Trouble = true,
			lazy = true,
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

M.plugins = {
	function()
		local plugins = require("lazy.core.config").plugins
		local total = 0
		local init = 0
		for _, plugin in pairs(plugins) do
			total = total + 1
			if plugin._.loaded ~= nil then
				init = init + 1
			end
		end
		return init .. "/" .. total
	end,
	icon = " ",
	color = function()
		local plugins = require("lazy.core.config").plugins
		local has_errors = require("lazy.core.plugin").has_errors

		for _, plugin in pairs(plugins) do
			if has_errors(plugin) then
				return "StatuslineError"
			end
		end

		if require("lazy.status").has_updates() then
			return "StatuslineOk"
		end

		return "StatuslineNormal"
	end,
}

return M
