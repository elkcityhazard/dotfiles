vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
--vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
--vim.keymap.set("n", "<leader>ptn", function()
--	vim.cmd("tabnew")
--	vim.cmd("Ex")
--end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>pv", vim.cmd.Oil)
vim.keymap.set("n", "<leader>pe", vim.cmd.Lex)

-- Buffers
vim.keymap.set("n", "<leader>bf", vim.cmd.bfirst)
vim.keymap.set("n", "<leader>bl", vim.cmd.blast)
vim.keymap.set("n", "<leader>bn", vim.cmd.bnext)
vim.keymap.set("n", "<leader>bp", vim.cmd.bprevious)
vim.keymap.set("n", "<leader>bd", vim.cmd.bdelete)

-- Remap Splits
vim.api.nvim_set_keymap("n", "<Leader>sh", ":split<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>sv", ":vsplit<CR>", { noremap = true, silent = true })

-- LSP
--
--  note: diagnostics are not exclusive to lsp servers
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
