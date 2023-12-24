local setupUI = function(opts)
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = opts.border }
  )

  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = opts.border }
  )

  vim.diagnostic.config({
    float = { border = opts.border }
  })
end

local defaultKeymaps = function(opts)
  local buffer = opts.buffer or 0
  local map = function(m, lhs, rhs)
    local key_opts = {
      buffer = buffer,
      desc = "lsp.lua"
    }
    SMap(m, lhs, rhs, key_opts)
  end

  local async = function(fn)
    return function()
      fn({ async = true })
    end
  end

  map('n', 'K', vim.lsp.buf.hover)
  map('n', 'gd', vim.lsp.buf.definition)
  map('n', 'gD', vim.lsp.buf.declaration)
  map('n', 'gi', vim.lsp.buf.implementation)
  map('n', 'go', vim.lsp.buf.type_definition)
  map('n', 'gs', vim.lsp.buf.signature_help)
  map('n', '<leader><F2>', vim.lsp.buf.rename)
  map({ 'n', 'v' }, '<leader>ff', async(vim.lsp.buf.format))
  map('n', '<leader>ca', vim.lsp.buf.code_action)

  if vim.lsp.buf.range_code_action then
    map('x', '<leader>ca', vim.lsp.buf.range_code_action)
  else
    map('x', '<leader>ca', vim.lsp.buf.code_action)
  end

  map('n', '[d', vim.diagnostic.goto_prev)
  map('n', ']d', vim.diagnostic.goto_next)
end

local mason = require("mason")
local mason_lspcfg = require("mason-lspconfig")
local neodev = require("neodev")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

setupUI({ border = "rounded" })
mason.setup()
mason_lspcfg.setup({
  ensure_installed = {
  }
})
neodev.setup({})

local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
lsp_capabilities = cmp_nvim_lsp.default_capabilities(lsp_capabilities)

local lsp_attach = function(client, bufnr)
  defaultKeymaps({ buffer = bufnr })
end

local lspconfig = require('lspconfig')
mason_lspcfg.setup_handlers({
  function(server_name)
    lspconfig[server_name].setup({
      on_attach = lsp_attach,
      capabilities = lsp_capabilities,
    })
  end,
})

SMap('n', '<leader>e', vim.diagnostic.open_float)
SMap({ 'n', 'v' }, '<leader>fg', ":Format<CR>")
