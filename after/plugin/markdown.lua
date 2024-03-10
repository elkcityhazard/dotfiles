-- Create an autocmd for the 'BufEnter' and 'FileType' events
vim.api.nvim_create_autocmd({ 'BufEnter', 'FileType' }, {
    group = "megalawnalien",
    pattern = '*.md',
    callback = function()
        -- Set line wrap options for Markdown files
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
    end,
})
