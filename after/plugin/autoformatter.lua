-- Utilities for creating configurations
local util = require("formatter.util")

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
local formatter = require("formatter").setup({
	-- Enable or disable logging
	logging = true,
	-- Set the log level
	log_level = vim.log.levels.WARN,
	-- All formatter configurations are opt-in
	filetype = {
		-- Formatter configurations for filetype "lua" go here
		-- and will be executed in order
		lua = {
			-- "formatter.filetypes.lua" defines default configurations for the
			-- "lua" filetype
			require("formatter.filetypes.lua").stylua,

			-- You can also define your own configuration
			function()
				-- Supports conditional formatting
				--if util.get_current_buffer_file_name() == "special.lua" then
				--	return nil
				--end

				-- Full specification of configurations is down below and in Vim help
				-- files
				return {
					exe = "stylua",
					args = {
						"--search-parent-directories",
						"--stdin-filepath",
						util.escape_path(util.get_current_buffer_file_path()),
						"--",
						"-",
					},
					stdin = true,
				}
			end,
		},
		javascript = {
			require("formatter.filetypes.javascript").prettierd,
		},
		go = {
			require("formatter.filetypes.go").goimports,
		},
		css = {
			require("formatter.filetypes.css").prettierd,
		},
		json = {
			require("formatter.filetypes.json").prettierd,
		},
		php = {
			require("formatter.filetypes.php").php_cs_fixer,
		},
	},
})

-- this keymap allows us to format whenever we please

vim.keymap.set("n", "<leader>fmt", function()
	vim.cmd("Format")
end, { noremap = true, silent = true })

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
augroup("__formatter__", { clear = true })
autocmd("BufWritePost", {
	group = "__formatter__",
	command = ":FormatWriteLock",
})
