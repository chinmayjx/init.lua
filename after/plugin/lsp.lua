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
setupUI({ border = "rounded" })

local defaultKeymaps = function(opts)
  local fmt = function(cmd) return function(str) return cmd:format(str) end end

  local buffer = opts.buffer or 0

  local lsp = fmt('<cmd>lua vim.lsp.%s<cr>')
  local diagnostic = fmt('<cmd>lua vim.diagnostic.%s<cr>')

  local map = function(m, lhs, rhs)
    local key_opts = { buffer = buffer }
    SMap(m, lhs, rhs, key_opts)
  end

  map('n', 'K', lsp 'buf.hover()')
  map('n', 'gd', lsp 'buf.definition()')
  map('n', 'gD', lsp 'buf.declaration()')
  map('n', 'gi', lsp 'buf.implementation()')
  map('n', 'go', lsp 'buf.type_definition()')
  map('n', 'gs', lsp 'buf.signature_help()')
  map('n', '<leader><F2>', lsp 'buf.rename()')
  map('n', '<leader>ff', lsp 'buf.format({async = true})')
  map('v', '<leader>ff', lsp 'buf.format({async = true})')
  map('n', '<leader>ca', lsp 'buf.code_action()')

  if vim.lsp.buf.range_code_action then
    map('x', '<leader>ca', lsp 'buf.range_code_action()')
  else
    map('x', '<leader>ca', lsp 'buf.code_action()')
  end

  map('n', '[d', diagnostic 'goto_prev()')
  map('n', ']d', diagnostic 'goto_next()')
end

local nvimLuaLS = function (opts)
  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, 'lua/?.lua')
  table.insert(runtime_path, 'lua/?/init.lua')

  local config = {
    settings = {
      Lua = {
        telemetry = {enable = false},
        runtime = {
          version = 'LuaJIT',
          path = runtime_path,
        },
        diagnostics = {
          globals = {'vim'}
        },
        workspace = {
          checkThirdParty = false,
          library = {
            vim.fn.expand('$VIMRUNTIME/lua'),
            vim.fn.stdpath('config') .. '/lua'
          }
        }
      }
    }
  }

  return vim.tbl_deep_extend('force', config, opts or {})
end

require('mason').setup()

require('mason-lspconfig').setup({
  ensure_installed = {
  }
})

local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local lsp_attach = function(client, bufnr)
  defaultKeymaps({ buffer = bufnr })
end

local lspconfig = require('lspconfig')
require('mason-lspconfig').setup_handlers({
  function(server_name)
    if server_name == 'lua_ls' then
      return lspconfig.lua_ls.setup(nvimLuaLS({
      on_attach = lsp_attach,
      capabilities = lsp_capabilities,
    }))
    end
    lspconfig[server_name].setup({
      on_attach = lsp_attach,
      capabilities = lsp_capabilities,
    })
  end,
})

Map('n', '<leader>e', vim.diagnostic.open_float)
Map('n', '<leader>fg', ":Format<CR>")
Map('v', '<leader>fg', ":Format<CR>")
Map('n', '<leader><F2>', function() vim.lsp.buf.rename(vim.fn.input("rename to: ")) end)
