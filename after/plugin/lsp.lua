local cmp = require("cmp")
require("luasnip.loaders.from_vscode").lazy_load({
	include = { "sql", "mysql" },
})
require("luasnip.loaders.from_snipmate").lazy_load({
	include = { "gopls", "typescriptreact", "javascript", "php", "sql", "mysql" },
})

cmp.setup({
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "sql" },
	}),
	mapping = cmp.mapping.preset.insert({
		-- Enter key confirms completion item
		["<CR>"] = cmp.mapping.confirm({ select = false }),

		-- Ctrl + space triggers completion menu
		["<C-Space>"] = cmp.mapping.complete(),
	}),
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
})

local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

local default_setup = function(server)
	if server == "ts_ls" then
		server = "ts_ls"
	end
	require("lspconfig")[server].setup({
		capabilities = lsp_capabilities,
	})
end

require("mason").setup({})

require("mason-lspconfig").setup({
	ensure_installed = {
		"html",
		"cssls",
		"ts_ls",
		"gopls",
		"emmet_language_server",
		"tailwindcss",
		"yamlls",
		"prosemd_lsp",
		"clangd",
		"harper_ls",
		"rust_analyzer",
		"jsonls",
		"docker_compose_language_service",
		"dockerls",
		"graphql",
		"phpactor",
		"lua_ls",
		"intelephense",
		"sqls",
		"sqlls",
	},
	handlers = {
		default_setup,
		intelephense = function()
			require("lspconfig").intelephense.setup({
				root_dir = function()
					return vim.loop.cwd()
				end,
			})
		end,
		phpactor = function()
			require("lspconfig").phpactor.setup({
				root_dir = function()
					return vim.loop.cwd()
				end,
				init_options = {
					["language_server.diagnostics_on_update"] = true,
					["language_server.diagnostics_on_open"] = false,
					["language_server.diagnostics_on_save"] = false,
					["language_server_phpstan.enabled"] = true,
					["language_server_psalm.enabled"] = false,
				},
			})
		end,
		graphql = function()
			require("lspconfig").graphql.setup({
				root_dir = function()
					return vim.loop.cwd()
				end,
			})
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
					globals = { "cwd", "vim", "vim.loop.cwd" },
				},
			})
		end,
		clangd = function()
			require("lspconfig").clangd.setup({})
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
			require("lspconfig").gopls.setup({
				filetypes = {
					"gohtml",
					"go",
				},
			})
		end,
		tailwindcss = function()
			require("lspconfig").tailwindcss.setup({})
		end,
		emmet_language_server = function()
			require("lspconfig").emmet_language_server.setup({
				filetypes = {
					"gohtml",
					"gotmpl",
					"go",
					"typescriptreact",
					"jsx",
					"js",
					"ts",
					"html",
					"css",
					"php",
					"scss",
					"sql",
					"mysql",
				},
			})
		end,
		cssls = function()
			--Enable (broadcasting) snippet capability for completion
			local css_capabilities = vim.lsp.protocol.make_client_capabilities()
			css_capabilities.textDocument.completion.completionItem.snippetSupport = true

			require("lspconfig").cssls.setup({
				capabilities = css_capabilities,
				filetypes = {
					"gohtml",
					"gotmpl",
					"css",
					"scss",
				},
			})
		end,
		html = function()
			local html_capabilities = vim.lsp.protocol.make_client_capabilities()
			html_capabilities.textDocument.completion.completionItem.snippetSupport = true

			require("lspconfig").html.setup({
				filetypes = { "html", "gohtml", "gotmpl" },
				capabilities = html_capabilities,
			})
		end,
		lua_ls = function()
			require("lspconfig").lua_ls.setup({
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = {
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
							},
						},
					},
				},
			})
		end,
		sqls = function()
			require("lspconfig").sqls.setup({
				capabilities = lsp_capabilities,
				root_dir = function()
					return vim.loop.cwd()
				end,
			})
		end,
		sqlls = function()
			require("lspconfig").sqlls.setup({
				capabilities = lsp_capabilities,
				root_dir = function()
					return vim.loop.cwd()
				end,
			})
		end,
	},
})
