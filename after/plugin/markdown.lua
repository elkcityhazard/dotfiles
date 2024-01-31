-- Create a new augroup named 'MarkdownWrap'
local markdown_wrap_group = vim.api.nvim_create_augroup('MarkdownWrap', { clear = true })

-- Create an autocmd for the 'BufEnter' and 'FileType' events
vim.api.nvim_create_autocmd({'BufEnter', 'FileType'}, {
  group = markdown_wrap_group,
  pattern = '*.md',
  callback = function()
    -- Set line wrap options for Markdown files
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})
