local M = {}

Modified = false
Multiproject = false

M.cwd = {
	function()
		local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
		if Multiproject then
			return "  " .. cwd
		end
		return "  " .. cwd
	end,

	color = function()
		local dx = vim.diagnostic
		if #dx.get(nil, { severity = dx.severity.ERROR }) > 0 then
			return "StatuslineError"
		end
		if #dx.get(nil, { severity = dx.severity.WARN }) > 0 then
			return "StatuslineWarn"
		end
		return "StatuslineNormal"
	end,
}

M.git = {
	"branch",
	icon = "",
	color = function()
		local git_status = vim.fn.systemlist("git status --porcelain " .. vim.fn.expand("%:p"))
		if type(git_status) ~= "table" then
			return "StatuslineError"
		end

		if #git_status == 0 then
			return "StatuslineNormal"
		end

		if git_status[1]:sub(1, 1) == "?" then
			return "StatuslineError"
		end

		return "StatuslineOk"
	end,
}

local function last_word(str)
	return string.match(str, "[^% ]+$")
end

local special = {
	netrw = true,
	Trouble = true,
	lazy = true,
	lspinfo = true,
	["dapui_watches"] = last_word,
	["dapui_breakpoints"] = last_word,
	["dapui_stacks"] = last_word,
	["dapui_scopes"] = last_word,
}

M.filetype = {
	"filetype",
	icon_only = true,
	colored = true,

	cond = function()
		return not special[vim.bo.ft]
	end,

	padding = { left = 1, right = 0 },
}

M.filename = {
	function()
		local fname = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":t")
		if fname == "" then
			return ""
		end

		if type(special[vim.bo.ft]) == "function" then
			return special[vim.bo.ft](fname)
		end

		if special[vim.bo.ft] ~= nil then
			return fname
		end

		local parent = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":h:t")
		return parent .. "/" .. fname
	end,

	color = function()
		local dx = vim.diagnostic
		if #dx.get(0, { severity = dx.severity.ERROR }) > 0 then
			return "StatuslineError"
		end
		if #dx.get(0, { severity = dx.severity.WARN }) > 0 then
			return "StatuslineWarn"
		end
		if vim.o.modified then
			return "StatuslineOk"
		end
		return "StatuslineNormal"
	end,
}

M.inactive_filename = {
	function()
		local fname = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":t")
		if fname == "" then
			return ""
		end

		if type(special[vim.bo.ft]) == "function" then
			return special[vim.bo.ft](fname)
		end

		if special[vim.bo.ft] ~= nil then
			return fname
		end

		local parent = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":h:t")
		return parent .. "/" .. fname
	end,

	color = function()
		local dx = vim.diagnostic
		if #dx.get(0, { severity = dx.severity.ERROR }) > 0 then
			return "StatuslineErrorInactive"
		end
		if #dx.get(0, { severity = dx.severity.WARN }) > 0 then
			return "StatuslineWarnInactive"
		end
		if vim.o.modified then
			return "StatuslineOkInactive"
		end
		return "StatuslineNormalInactive"
	end,
}

M.unsaved = {
	function()
		if Modified then
			return "Unsaved changes!"
		end
		return ""
	end,
	color = "StatuslineOk",
}

M.diff = {
	"diff",
	diff_color = {
		added = "StatuslineOk",
		modified = "StatuslineWarn",
		removed = "StatuslineError",
	},
}

M.diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	symbols = { error = " ", warn = " ", info = " ", hint = " " },
	diagnostics_color = {
		color_error = "StatuslineError",
		color_warn = "StatuslineWarn",
		color_info = "StatuslineInfo",
	},
}

return M
