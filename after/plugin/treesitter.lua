vim.filetype.add({
  extension = {
    gohtml = "gohtml",
  }
})


require('nvim-treesitter.configs').setup({
  ensure_installed = {
    "c",
    "lua",
    "vim",
    "vimdoc",
    "query",
    "markdown",
    "markdown_inline",
    "javascript",
    "typescript",
    "go",
    "jsdoc",
    "json",
    "make",
    "yaml",
    "html",
    "gotmpl",
    "helm",
    "css",
    "sql"
  },

  sync_install = true,

  auto_install = true,

  ignore_install = {},

  modules = {},

  highlight = {
    enable = true,
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,

    additional_vim_regex_highlighting = false,
  },
})


vim.treesitter.language.register('gotmpl', 'gohtml')
