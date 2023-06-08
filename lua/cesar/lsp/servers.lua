return {
	bashls = true,
	pyright = true,
	svelte = true,
	yamlls = true,
	html = true,
	cssls = true,
	graphql = true,
	-- eslint = true,
	tsserver = {
		init_options = require("nvim-lsp-ts-utils").init_options,
		cmd = { "typescript-language-server", "--stdio" },
		filetypes = {
			"javascript",
			"javascriptreact",
			"javascript.jsx",
			"typescript",
			"typescriptreact",
			"typescript.tsx",
		},
	},
	jsonls = {
		settings = {
			json = {
				schemas = require("schemastore").json.schemas(),
				validate = { enable = true },
			},
		},
	},
	clangd = {
		cmd = {
			"clangd",
			"--background-index",
			"--suggest-missing-includes",
			"--clang-tidy",
			"--header-insertion=iwyu",
		},
		init_options = {
			clangdFileStatus = true,
		},
	},
	rust_analyzer = {
		cmd = { "rustup", "run", "rust-analyzer" },
		settings = {
			["rust-analyzer"] = {
				checkOnSave = {
					command = "clippy",
				},
			},
		},
	},
	lua_ls = {
		settings = {
			Lua = {
				workspace = { checkThirdParty = false },
				semantic = { enable = false },
				diagnostics = {
					globals = {
						"User",
						"Plugin",
					},
				},
			},
		},
	},
}
