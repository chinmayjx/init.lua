local lint = require('lint')

assert(lint, 'Lint is not loaded')

lint.linters_by_ft = {
  python = { 'pylint' }
}


vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    lint.try_lint()
  end,
})


local pylint = lint.linters.pylint

pylint.env = {
  PYTHONPATH = vim.fn.expand(".") ..
  ":" .. vim.fn.expand("~/.local/share/nvim/mason/packages/pylint/venv/lib/python3.12/site-packages/")
}
pylint.cmd = 'python'
pylint.args = { '-m', 'pylint', '-f', 'json' }
