local nmap = require(User .. ".config.utils").nmap

return function()
	vim.diagnostic.config({
		underline = true,
		virtual_text = {
			severity = nil,
			source = "if_many",
			format = nil,
		},
		signs = true,

		-- options for floating windows:
		float = {
			show_header = true,
			-- border = "rounded",
			-- source = "always",
			format = function(d)
				if not d.code and not d.user_data then
					return d.message
				end

				local t = vim.deepcopy(d)
				local code = d.code
				if not code then
					if not d.user_data.lsp then
						return d.message
					end

					code = d.user_data.lsp.code
				end
				if code then
					t.message = string.format("%s [%s]", t.message, code):gsub("1. ", "")
				end
				return t.message
			end,
		},

		-- general purpose
		severity_sort = true,
		update_in_insert = false,
	})

	-- Go to the next diagnostic, but prefer going to errors first
	-- In general, I pretty much never want to go to the next hint
	local severity_levels = {
		vim.diagnostic.severity.ERROR,
		vim.diagnostic.severity.WARN,
		vim.diagnostic.severity.INFO,
		vim.diagnostic.severity.HINT,
	}

	local get_highest_error_severity = function()
		for _, level in ipairs(severity_levels) do
			local diags = vim.diagnostic.get(0, { severity = { min = level } })
			if #diags > 0 then
				return level, diags
			end
		end
	end

  Keymap({
    [""] = {
      {
        "Next diagnostic",
        "]d",
        function ()
          vim.diagnostic.goto_next({
            severity = get_highest_error_severity(),
            wrap = true,
            float = true,
          })
        end
      },
      {
        "Previous diagnostic",
        "[d",
        function ()
          vim.diagnostic.goto_prev({
            severity = get_highest_error_severity(),
            wrap = true,
            float = true,
          })
        end
      },
      {
        "Diagnostics list",
        "<leader>dl",
        function ()
          vim.diagnostic.open_float({
            scope = "line",
          })
        end
      },
    }
  })
end
