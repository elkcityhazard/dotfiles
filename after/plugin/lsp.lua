local function set_lsp_cwd()
  local filename = vim.api.nvim_buf_get_name(0)
  local project_root = vim.fn.fnamemodify(filename, ":p:h")

  if vim.fn.isdirectory(project_root) == 1 then
    vim.cmd('lcd ' .. project_root)
  end
end

local function on_attach(client, bufnr)
  set_lsp_cwd()
  local buf_set_keymap = function(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap = true, silent = true }

  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
end

local default_capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = require("blink.cmp").get_lsp_capabilities(default_capabilities)
vim.lsp.config('lua_ls',{ capabilities = capabilities })
vim.lsp.config('gopls',{ capabilities = capabilities })
vim.lsp.config('svelte',{
  capabilites = capabilities,
  root_dir = function()
    return vim.uv.cwd()
  end,
  on_attach = on_attach(vim.lsp.client, 0)
})
-- json
local function enable_json_lsp()
  local jsonCapabilities = capabilities
  jsonCapabilities.textDocument.completion.completionItem.snippetSupport = true
  vim.lsp.config('jsonls',{
    capabilities = jsonCapabilities,
    root_dir = vim.uv.cwd(),
    on_attach = on_attach,
  })
end

enable_json_lsp()

-- markdown
local function enable_md_lsp()
  local mdCapabilities = capabilities
  vim.lsp.config('markdown_oxide',{
    capabilities = vim.tbl_deep_extend(
      'force',
      mdCapabilities,
      {
        workspace = {
          didChangeWatchedFiles = {
            dynamicRegistration = true,
          },
        },
      }
    ),
  })

  local check_codelens_support = function(client, bufnr)
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    for _, c in ipairs(clients) do
      if c.server_capabilities.codeLensProvider then
        return true
      end
    end
    return false
  end

  vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertLeave', 'CursorHold', 'LspAttach', 'BufEnter' }, {
    buffer = bufnr,
    callback = function()
      if check_codelens_support() then
        vim.lsp.codelens.refresh({ bufnr = 0 })
      end
    end
  })
  -- trigger codelens refresh
  vim.api.nvim_exec_autocmds('User', { pattern = 'LspAttached' })
end

enable_md_lsp()

-- emmet
vim.lsp.config('emmet_language_server',{
  capabilities = capabilities,
  filetypes = { "gohtml", "html", "css", "typescript", "scss" },
})
-- CSS

local function enable_css(caps)
  caps.textDocument.completion.completionItem.snippetSupport = true

  vim.lsp.config('cssls',{
    capabilities = caps,
    filetypes = { "css", "scss" },
    root_dir = function()
      return vim.uv.cwd()
    end
  })
end

enable_css(capabilities)

-- Javascripts
vim.lsp.config('denols',{ capabilities = capabilities })
vim.lsp.config('ts_ls',{ capabilities = capabilities })

-- PHP
vim.lsp.config('phpactor',{
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
vim.lsp.config('intelephense',{
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

vim.lsp.config('sqls',{
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
