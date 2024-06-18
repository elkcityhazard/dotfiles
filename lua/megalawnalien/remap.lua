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

-- Oil

vim.keymap.set("n", "<leader>po", function()
    local oil = require('oil')

    local current_dir = oil.get_current_dir()

    oil.open(current_dir)
end
)


vim.keymap.set("n", "<leader>pi", function()
    local oil = require("oil")

    oil.open_preview({
        vertical = true,
    })
end
)
