local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local parse = ls.parser.parse_snippet

local js_root = {
  parse("clg", "console.log($1);$0"),
}

local python_snips = {
  parse("fr", "for ${1:i} in range($2):\n\t${3:pass}\n$0")
}

local snips = {
  python = python_snips,
  javascript = js_root,
  typescript = js_root,
}

for k, v in pairs(snips) do
  ls.add_snippets(k, v, { key = k })
end
SMap({ "i", "s" }, "<C-n>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end)
SMap({ "i", "s" }, "<C-p>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end)

SMap("n", "<leader>sr", ":source ~/.config/nvim/after/plugin/luasnip.lua<CR>")
