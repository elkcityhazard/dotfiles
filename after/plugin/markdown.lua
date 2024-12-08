
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "*.md",
        "markdown",
},
    callback = function ()
        vim.opt_local.textwidth = 75
        vim.opt_local.wrap = true
    end,
})

