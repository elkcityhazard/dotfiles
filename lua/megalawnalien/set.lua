vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0

-- clipboard
vim.opt.clipboard = "unnamedplus"

-- netrw max width
vim.g.netrw_winsize = 20

vim.loader.enable()

-- code folding
--
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldcolumn = "2"
vim.opt.foldtext = ""
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 0
vim.opt.foldnestmax = 3
vim.opt.foldenable = true    -- Enable folding
vim.opt.foldmarker = '{{,}}' -- Markers for custom folding

-- Map spacebar to toggle folds
vim.api.nvim_set_keymap('n', '<Space>', 'za', { noremap = true, silent = true })
