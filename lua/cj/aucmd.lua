local python = require("cj.python")
local grpName = "LuaCJaucmd"
local grp = vim.api.nvim_create_augroup(grpName, { clear = true })

local bufEnter = function(opts)
  local ft = vim.bo.filetype
  if ft == "python" then
    SMap("n", "<leader>up", python.pytestExecuteFn, { desc = "pytest run function", buffer = true })
    SMap("n", "<leader>ul", python.executeLastTest, { desc = "executeLastTest", buffer = true })
    SMap("n", "<leader>oi", function () vim.cmd("PyrightOrganizeImports") end, { desc = "organize imports", buffer = true})
  end
end

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = grpName,
  pattern = "*",
  callback = bufEnter
})

local bufNew = function(opts)
end

vim.api.nvim_create_autocmd({ "BufNew" }, {
  group = grpName,
  pattern = "*",
  callback = bufNew
})
