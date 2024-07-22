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


return {
  pytestExecuteFn = pytestExecuteFn,
  executeLastTest = executeLastTest
}
