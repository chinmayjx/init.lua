local ls = require("luasnip")
local parse = ls.parser.parse_snippet

local js_root = {
  parse("clg", "console.log($1);$0"),
}

local python_snips = {
  parse("fr", "for ${1:i} in range($2):\n\t${3:pass}\n$0"),
  parse("copy", "import pyperclip\npyperclip.copy($1)$0"),
}

local lua_snips = {
  parse("vi", "vim.inspect($1)$0")
}

local snips = {
  python = python_snips,
  javascript = js_root,
  typescript = js_root,
  lua = lua_snips,
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
