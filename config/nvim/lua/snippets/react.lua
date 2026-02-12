local ls = require("luasnip")
local s  = ls.snippet
local t  = ls.text_node
local i  = ls.insert_node
local f  = ls.function_node

ls.add_snippets("typescriptreact", {
  s("fc", {
    t("const "),
    f(function()
      return vim.fn.expand("%:t:r")
    end),
    t(" = () => {\n  return (\n    <div>\n      "),
    i(0),
    t("\n    </div>\n  );\n};\n\nexport default "),
    f(function()
      return vim.fn.expand("%:t:r")
    end),
  }),

})

/*ls.add_snippets("javascriptreact", {
  s("fc", {
    t("const "),
    f(function()
      return vim.fn.expand("%:t:r")
    end),
    t(" = () => {\n  return (\n    <div>\n      "),
    i(0),
    t("\n    </div>\n  );\n};\n\nexport default "),
    f(function()
      return vim.fn.expand("%:t:r")
    end),
  }),

})*/