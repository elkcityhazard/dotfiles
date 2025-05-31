return {
  {
    'saghen/blink.compat',
    -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
    version = '*',
    -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
    lazy = true,
    -- make sure to set opts so that lazy.nvim calls blink.compat's setup
    opts = {},
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" }
      },
      "moyiz/blink-emoji.nvim",
      "ray-x/cmp-sql",
    },
    version = "1.*",

    opts = {
      keymap = { preset = "default" },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },
      signature = {
        enabled = true,
      },
      completion = {
        documentation = { auto_show = true },
        menu = {
          border = "rounded"
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "emoji", "sql" },
        providers = {
          emoji = {
            module = "blink-emoji",
            name = "Emoji",
            score_offset = 15,
            opts = {
              insert = true,
            },
            should_show_items = function()
              return vim.tbl_contains({ "gitcommit", "markdown" }, vim.o.filetype)
            end,
          },
          sql = {
            name = "sql",
            module = "blink.compat.source",
            score_offset = -3,
            opts = {},
            should_show_items = function()
              return vim.tbl_contains({ "sql", "mysql" }, vim.o.filetype)
            end,
          },
        },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
      snippets = { preset = 'luasnip' },
      -- ensure you have the `snippets` source (enabled by default)
    },
    opts_extend = { "sources.default" },
  }
}
