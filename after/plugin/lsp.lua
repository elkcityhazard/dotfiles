vim.api.nvim_create_augroup("megalawnalien", {})
local autocmd = vim.api.nvim_create_autocmd

-- note: diagnostics are not exclusive to lsp servers
-- so these can be global keybindings
vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>")
vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")

vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",
    callback = function(event)
        local opts = { buffer = event.buf }

        -- these will be buffer-local keybindings
        -- because they only work if you have an active language server

        vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
        vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
        vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
        vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
        vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
        vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
        vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
        vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
        vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
        vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    end,
})

local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

--helper function for cssls

local cssls_capabilities = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    return capabilities
end

local default_setup = function(server)
    -- emmet_language_server
    require("lspconfig").emmet_language_server.setup({
        capabilities = lsp_capabilities,
    })



    require("lspconfig").cssls.setup({
        capabilities = cssls_capabilities()
    })

    -- lua_ls setup
    require("lspconfig").lua_ls.setup({
        capabilities = lsp_capabilities,
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT",
                },
                diagnostics = {
                    globals = { "vim" },
                },
                workspace = {
                    library = {
                        vim.env.VIMRUNTIME,
                    },
                },
            },
        },
    })

    -- Setup Gopls based on Go Documentation

    require("lspconfig").gopls.setup({
        capabilities = lsp_capabilities,
        settings = {
            gopls = {
                analyses = {
                    unusedparams = true,
                },
                staticcheck = true,
                gofumpt = true,
            },
        },
    })


    -- javascript/typescript

    require("lspconfig").tsserver.setup({
        capabilities = lsp_capabilities,
    })

    -- dockerls
    require("lspconfig").dockerls.setup({
        capabilities = lsp_capabilities
    })

    -- docker compose
    require("lspconfig").docker_compose_language_service.setup {}

    -- intelephense
    require("lspconfig").intelephense.setup({
        capabilities = lsp_capabilities,
        settings = {
            intelephense = {
                stubs = {
                    "wordpress",
                    "wordpress-globals",
                }
            },
        },
    })

    require("lspconfig").phpactor.setup({
        capabilities = lsp_capabilities
    })

    print(server)
end

-- pass default_setup to mason

require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = {},
    handlers = {
        default_setup,
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
            require("luasnip").lsp_expand(args.body)
        end,
    },
})



-- Configure format on save

autocmd('BufWritePre', {
    pattern = "*",
    group = "megalawnalien",
    callback = function()
        vim.lsp.buf.format { async = false }
        print("progress saved")
    end,
})


-- Configure go import pre buffer save

autocmd("BufWritePre", {
    pattern = "*.go",
    group = "megalawnalien",
    callback = function()
        local params = vim.lsp.util.make_range_params()
        params.context = { only = { "source.organizeImports" } }
        -- buf_request_sync defaults to a 1000ms timeout. Depending on your
        -- machine and codebase, you may want longer. Add an additional
        -- argument after params if you find that you have to write the file
        -- twice for changes to be saved.
        -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
        for cid, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
                if r.edit then
                    local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                    vim.lsp.util.apply_workspace_edit(r.edit, enc)
                end
            end
        end
        vim.lsp.buf.format({ async = false })
    end,
})
