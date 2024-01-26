local run = require("cj.run")

local function pytestExecuteFn()
  vim.cmd.w()
  local file = vim.fn.expand("%")
  local fn = CurrentFunction()
  run.runInTerminal("pytest " .. file .. "::" .. fn)
end

SMap("n", "<leader>up", pytestExecuteFn, {desc = "pytest run function"})
