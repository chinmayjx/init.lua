local lspz = require('lsp-zero').preset({})

lspz.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, noremap = true }
  lspz.default_keymaps({ buffer = bufnr })
  vim.keymap.set("n", "<leader>ff", vim.lsp.buf.format, opts)
end)
require('lspconfig').lua_ls.setup(lspz.nvim_lua_ls())
lspz.setup()

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
cmp.setup({
  mapping = {
    ['<Tab>'] = cmp_action.luasnip_supertab(),
    ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-u>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources(
    {
      { name = 'nvim_lsp' }
    },
    {
      { name = 'buffer' },
    }
  )
})

Map('n', '<leader>e', vim.diagnostic.open_float)
Map('n', '<leader>fg', ":Format<CR>")
Map('n', '<leader><F2>', function() vim.lsp.buf.rename(vim.fn.input("rename to: ")) end)
