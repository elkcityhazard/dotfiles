-- so annoying when you save and all your code folds

local disable_fold_on_save = function()
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
      vim.opt_local.foldenable = false
    end
  })
end

disable_fold_on_save()
