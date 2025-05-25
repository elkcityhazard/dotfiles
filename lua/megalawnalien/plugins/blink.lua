return {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets",
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build = "make install_jsregexp"
    }
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
    completion = { documentation = { auto_show = true } },
    snippets = { preset = 'luasnip' },
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "omni" },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
