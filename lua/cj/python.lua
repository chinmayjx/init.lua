local run = require("cj.run")

local function pytestExecuteFn()
  vim.cmd.w()
  local file = vim.fn.expand("%")
  local fn = CurrentFunction()
  if fn == nil then
    return
  end
  run.runInTerminal("python -m pytest -s " .. file .. "::" .. fn)
end

SMap("n", "<leader>up", pytestExecuteFn, {desc = "pytest run function"})
