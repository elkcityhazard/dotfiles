local cmp = require("blink.cmp")

local lsp_capabilities = cmp.get_lsp_capabilities()

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
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			require("lspconfig").gopls.setup({
				filetypes = {
					"gohtml",
					"go",
				},
				capabilities = capabilities,
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
	},
})
