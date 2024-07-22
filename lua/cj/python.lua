local run = require("cj.run")

local lastTest = nil

local function pytestExecuteFn()
  vim.cmd.w()
  local file = vim.fn.expand("%")
  local fn, node = CurrentFunction({
    nameValidator = function(name)
      return name:sub(1, 4) == "test" or name:sub(-4) == "test"
    end
  })
  local class, _ = ContainingClass({ node = node })
  if fn == nil then
    return
  end
  if class ~= nil then
    fn = class .. "::" .. fn
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
