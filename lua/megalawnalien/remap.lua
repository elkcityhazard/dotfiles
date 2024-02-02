vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>ptn", function()
	vim.cmd("tabnew")
	vim.cmd("Ex")
end, { noremap = true, silent = true })

-- Codeium Remap
--
vim.g.codeium_tab_fallback = "<Tab>"
