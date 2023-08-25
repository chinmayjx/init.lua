local mru = require("cj.mru")
local projectDir = ".cjvim"

local saveWinBuffs = function(root)
  local winBuffs = mru.getWinBuffs()
  local js = {}
  for wid, buffs in pairs(winBuffs) do
    local winInfo = vim.fn.getwininfo(wid)
    if #winInfo > 0 then
      winInfo = winInfo[1]
      local ct = winInfo.tabnr
      if js[ct] == nil then
        js[ct] = {}
      end
      js[ct][#js[ct] + 1] = {}
      local ctBuffs = js[ct][#js[ct]]

      for _, bid in ipairs(buffs) do
        local bufInfo = vim.fn.getbufinfo(bid)
        if #bufInfo > 0 then
          bufInfo = bufInfo[1]
          local nm = bufInfo.name
          if nm:sub(1, 4) ~= "/tmp" then
            ctBuffs[#ctBuffs + 1] = nm
          end
        end
      end
    end
  end
  local json = vim.fn.json_encode(js)
  local f = io.open(JoinPath(root, "winBuffs.json"), "w")
  if f ~= nil then
    f:write(json)
    f:close()
  end
end

function SaveSession()
  local root = vim.fn.input("root: ", vim.fn.getcwd())
  if #root == 0 then
    return
  end
  root = JoinPath(root, projectDir)
  local dirExists = vim.fn.isdirectory(root)
  if dirExists == 0 then
    vim.fn.mkdir(root)
  end
  saveWinBuffs(root)
  vim.cmd("mks! " .. JoinPath(root, projectDir))
end
