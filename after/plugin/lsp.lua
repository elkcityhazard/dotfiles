local default_capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = require("blink.cmp").get_lsp_capabilities(default_capabilities)
require("lspconfig").lua_ls.setup({ capabilities = capabilities })
require("lspconfig").gopls.setup({ capabilities = capabilities })

-- Javascripts
require("lspconfig").denols.setup({ capabilities = capabilities })
require("lspconfig").ts_ls.setup({ capabilities = capabilities })

-- PHP
require("lspconfig").phpactor.setup({
  capabilities = capabilities,
  root_dir = function()
    return vim.loop.cwd()
  end,
  init_options = {
    ["language_server.diagnostics_on_update"] = false,
    ["language_server.diagnostics_on_open"] = false,
    ["language_server.diagnostics_on_save"] = false,
    ["language_server_phpstan.enabled"] = false,
    ["language_server_psalm.enabled"] = false,
  }
})

-- intelephense setup
require("lspconfig").intelephense.setup({
  capabilities = capabilities,
  settings = {
    intelephense = {
      stubs = {
        "bcmath",
        "bz2",
        "calendar",
        "Core",
        "curl",
        "zip",
        "zlib",
        "wordpress",
        "wordpress-stubs",
        "woocommerce",
        "acf",
        "acf-pro",
        "acf-pro-stubs",
        "woocommerce",
        "genesis",
        "polylang"
      },
      completion = {
        fullyQualifiedGlobalConstants = true,
        insertUseDeclaration = true
      },
      environment = {
        includePaths = {
          '/home/andrew/.config/composer/vendor/php-stubs/wordpress-globals/',
          '/home/andrew/.config/composer/vendor/php-stubs/wordpress-stubs/',
          '/home/andrew/.config/composer/vendor/php-stubs/acf-pro-stubs/',
          '/home/andrew/.config/composer/vendor/php-stubs/wordpress-seo-stubs/',
          '/home/andrew/.config/composer/vendor/php-stubs/wordpress-tests-stubs/',
        }
      },
      files = {
        maxSize = 500000
      }
    }
  },
  on_attach = function()
  end,
  root_dir = function()
    return vim.loop.cwd()
  end,
  filetypes = { "php" },
})

-- sqls

require("lspconfig").sqls.setup({
  capabilities = capabilities,
  root_dir = function(fname)
    return vim.uv.cwd()
  end
})

-- format on save
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("my.lsp", {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if not client then return end
    if vim.bo.filetype == "sql" then
      adHocSQLFormatting()
      return
    end

    -- format right before save
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("my.lsp", { clear = false }),
      buffer = args.buf,
      callback = function()
        vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
      end,
    })
  end,
})
