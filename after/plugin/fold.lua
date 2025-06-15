local vim = vim
local api = vim.api
local M = {}

-- Utility function to flatten a table
local function flatten(tbl)
  local flattened = {}
  for _, v in ipairs(tbl) do
    if type(v) == "table" then
      for _, lv in ipairs(flatten(v)) do
        table.insert(flattened, lv)
      end
    else
      table.insert(flattened, v)
    end
  end
  return flattened
end

-- Function to create a list of commands and convert them to autocommands
function M.nvim_create_augroups(definitions)
  for group_name, definition in pairs(definitions) do
    api.nvim_command("augroup " .. group_name)
    api.nvim_command("autocmd!")
    for _, def in ipairs(definition) do
      local command = table.concat(flatten({ "autocmd", def }), " ")
      api.nvim_command(command)
    end
    api.nvim_command("augroup END")
  end
end

local autoCommands = {
  -- Other autocommands
  open_folds = {
    { "BufReadPost,FileReadPost", "*", "normal zR" },
  },
}

M.nvim_create_augroups(autoCommands)
