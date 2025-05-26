require("conform").setup({
  formatters_by_ft = {
    sql = {
      "sleek"
    },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback"
  },
})


function adHocSQLFormatting()
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.sql",
    callback = function(args)
      require("conform").format({ bufnr = args.buf })
    end,
  })
end
