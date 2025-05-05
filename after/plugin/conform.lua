require("conform").setup({
	formatters_by_ft = {
		c = { "clang-format" },
		php = { "php" },
		lua = { "stylua" },
		-- Conform will run multiple formatters sequentially
		python = { "isort", "black" },
		-- You can customize some of the format options for the filetype (:help conform.format)
		rust = { "rustfmt", lsp_format = "fallback" },
		-- Conform will run the first available formatter
		javascript = { "prettierd", "prettier", stop_after_first = true },
		json = { "prettierd", "prettier", stop_after_first = true },
		css = { "prettierd", "prettier", stop_after_first = true },
		html = { "prettierd", "prettier", stop_after_first = true },
	},
	formatters = {
		php = {
			command = "php-cs-fixer",
			args = {
				"fix",
				"$FILENAME",
				"--allow-risky=yes",
			},
			stdin = false,
		},
	},
	opts = {
		linters_by_ft = {
			php = {},
		},
	},
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})
