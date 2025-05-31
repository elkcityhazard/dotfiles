require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load()
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local extras = require("luasnip.extras")
local rep = extras.rep
local fmt = require("luasnip.extras.fmt").fmt

-- keymap examples

vim.keymap.set({ "i", "s" }, "<A-k>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<A-j>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })
-- text node example
ls.add_snippets("go", {
  s("helloworld", {
    t('fmt.Println("hello world")')
  }),
  s("errhan", {
    t('if err != nil {'),
    i(1),
    t('}'),
  }),
  s("gofunc", fmt(
    [[
    go func(){{
    {body}
    }}()
    ]]
    , {
      body = i(1, "body")
    })),
  s("rfunc", fmt([[
      func ({shorthand} {receiver}) {funcName}({params}) ({returns}) {{
      {body}
      }}
      ]],
    {
      shorthand = i(1, "sh"),
      receiver = i(2, "receiver"),
      funcName = i(3, "functionNname"),
      params = i(4, "params"),
      returns = i(5, "returns"),
      body = i(6, "body"),
    }
  )),
  s("forselect", fmt([[
  for {{
    select {{
    {body}
    }}
  }}
  ]], {
    body = i(1, "// do channels")
  }))
})
