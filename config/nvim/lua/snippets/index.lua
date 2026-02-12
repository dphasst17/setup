local ls = require("luasnip")
local s  = ls.snippet
local t  = ls.text_node
local i  = ls.insert_node
local f  = ls.function_node

ls.snippets = {
  all = {
    s("date", f(function() return os.date("%Y-%m-%d") end, {})),
    s("fname", f(function(args, snip) return snip.env.TM_FILENAME end, {})),
    s("fn", f(function(args, snip) return snip.env.TM_FILENAME:match("(.+)%..+$") or snip.env.TM_FILENAME end, {})),
  },
}