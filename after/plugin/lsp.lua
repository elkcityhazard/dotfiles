-- default capabilities

local lsp_capabilities = require("cmp_nvim_lsp").default_capabilites

-- get default lsp config setup to pass into mason
local default_setup = function(server)
	require("lspconfig")[server].setup({
		capabilities = lsp_capabilities,
	})
end

-- require mason for installing stuff
require("mason").setup({})

-- setup mason lspconfig stuff
require("mason-lspconfig").setup({
	ensure_installed = {
		"html",
		"cssls",
		"tsserver",
		"gopls",
		"emmet_language_server",
		"tailwindcss",
		"yamlls",
		"prosemd_lsp",
		"intelephense",
		"clangd",
		"harper_ls",
		"rust_analyzer",
		"jsonls",
		"docker_compose_language_service",
		"dockerls",
		"graphql",
	},
	handlers = {
		default_setup,
		graphql = function()
			require("lspconfig").graphql.setup({})
		end,
		dockerls = function()
			require("lspconfig").dockerls.setup({
				settings = {
					docker = {
						languageserver = {
							formatter = {
								ignoreMultilineInstructions = true,
							},
						},
					},
				},
			})
		end,
		docker_compose_language_service = function()
			require("lspconfig").docker_compose_language_service.setup({})
		end,
		jsonls = function()
			--Enable (broadcasting) snippet capability for completion
			local json_capabilities = vim.lsp.protocol.make_client_capabilities()
			json_capabilities.textDocument.completion.completionItem.snippetSupport = true

			require("lspconfig").jsonls.setup({
				capabilities = json_capabilities,
			})
		end,
		rust_analyzer = function()
			require("lspconfig").rust_analyzer.setup({
				settings = {
					["rust-analyzer"] = {
						diagnostics = {
							enable = false,
						},
					},
				},
			})
		end,
		harper_ls = function()
			require("lspconfig").harper_ls.setup({
				settings = {
					["harper-ls"] = {
						userDictPath = "~/dict.txt",
					},
				},
			})
		end,
		clangd = function()
			require("lspconfig").clangd.setup({})
		end,
		intelephense = function()
			require("lspconfig").intelephense.setup({})
		end,
		prosemd_lsp = function()
			require("lspconfig").prosemd_lsp.setup({})
		end,
		yamlls = function()
			require("lspconfig").yamlls.setup({
				settings = {
					yaml = {
						schemas = {
							["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
							["../path/relative/to/file.yml"] = "/.github/workflows/*",
							["/path/from/root/of/project"] = "/.github/workflows/*",
						},
					},
				},
			})
		end,
		gopls = function()
			require("lspconfig").gopls.setup({})
		end,
		tailwindcss = function()
			require("lspconfig").tailwindcss.setup({})
		end,
		emmet_language_server = function()
			require("lspconfig").emmet_language_server.setup({})
		end,
		cssls = function()
			--Enable (broadcasting) snippet capability for completion
			local css_capabilities = vim.lsp.protocol.make_client_capabilities()
			css_capabilities.textDocument.completion.completionItem.snippetSupport = true

			require("lspconfig").cssls.setup({
				capabilities = css_capabilities,
			})
		end,
		html = function()
			local html_capabilities = vim.lsp.protocol.make_client_capabilities()
			html_capabilities.textDocument.completion.completionItem.snippetSupport = true

			require("lspconfig").html.setup({
				capabilities = html_capabilities,
			})
		end,
		lua_ls = function()
			require("lspconfig").lua_ls.setup({
				capabilities = lsp_capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})
		end,
	},
})

local cmp = require("cmp")

cmp.setup({
	sources = {
		{ name = "nvim_lsp" },
	},
	mapping = cmp.mapping.preset.insert({
		-- Enter key confirms completion item
		["<CR>"] = cmp.mapping.confirm({ select = false }),

		-- Ctrl + space triggers completion menu
		["<C-Space>"] = cmp.mapping.complete(),
	}),
	snippet = {
		expand = function(args)
			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip").lsp_expand(args.body)
		end,
	},
})
