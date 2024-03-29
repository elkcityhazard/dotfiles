vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>ptn", function()
    vim.cmd("tabnew")
    vim.cmd("Ex")
end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>pe", vim.cmd.Lex)



-- Buffers
vim.keymap.set("n", "<leader>bf", vim.cmd.bfirst)
vim.keymap.set("n", "<leader>bl", vim.cmd.blast)
vim.keymap.set("n", "<leader>bn", vim.cmd.bnext)
vim.keymap.set("n", "<leader>bp", vim.cmd.bprevious)
