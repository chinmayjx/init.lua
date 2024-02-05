local run = require("cj.run")

local lastTest = nil

local function pytestExecuteFn()
  vim.cmd.w()
  local file = vim.fn.expand("%")
  local fn = CurrentFunction()
  if fn == nil then
    return
  end
  lastTest = "python -m pytest -s " .. file .. "::" .. fn
  run.runInTerminal(lastTest)
end

local function executeLastTest()
  vim.cmd.w()
  run.runInTerminal(lastTest)
end

SMap("n", "<leader>up", pytestExecuteFn, {desc = "pytest run function"})
SMap("n", "<leader>ul", executeLastTest, {desc = "executeLastTest"})
