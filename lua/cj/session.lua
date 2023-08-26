local nvtree = require("nvim-tree.api").tree
local mru = require("cj.mru")

local WIN_BUFFS = "winBuffs.json"
local SESSION_VIM = "session.vim"
local WS_DIR = ".cjvim"
local PROJECT_HISTORY = vim.fs.normalize("~/.vimprojects")

local currentSession = nil

local function pickProject()
  local f = io.open(PROJECT_HISTORY, "r")
  if f ~= nil then
    local pjs = {}
    local dsp = {}
    for line in f:lines() do
      table.insert(pjs, line)
      table.insert(dsp, mru.fileNameLI(line))
    end
    SelectFromList(dsp, function(arg)
      if currentSession ~= nil then
        SaveSession()
      end
      vim.cmd("bufdo bw")
      LoadSession(pjs[arg.index])
    end)
  end
end
-- pickProject()
local function saveProjectToHistory(root)
  local f = io.open(PROJECT_HISTORY, "r")
  if f ~= nil then
    local st = { [root] = true }
    local nl = { root }
    for line in f:lines() do
      if #line > 0 and st[line] == nil then
        table.insert(nl, line)
        st[line] = true
      end
      if #nl > 50 then
        break
      end
    end
    f:close()
    f = io.open(PROJECT_HISTORY, "w")
    if f ~= nil then
      f:write(table.concat(nl, "\n"))
      f:close()
    end
  end
end

---@param root string
local function loadWinBuffs(root)
  local f = io.open(JoinPath(root, WIN_BUFFS), "r")
  if f ~= nil then
    local json = vim.fn.json_decode(f:read("*a"))
    local winBuffs = {}
    for _, winInfo in pairs(vim.fn.getwininfo()) do
      local ct = winInfo.tabnr
      local wid = winInfo.winid
      if winBuffs[wid] == nil then
        winBuffs[wid] = {}
      end
      winBuffs[wid] = json[ct][winInfo.winnr]
    end
    for _, buffs in pairs(winBuffs) do
      for i, bn in ipairs(buffs) do
        buffs[i] = vim.fn.bufnr(bn)
      end
    end
    mru.setWinBuffs(winBuffs)
  end
end

function LoadSession(root)
  if root ~= nil then
    root = JoinPath(root, WS_DIR)
  else
    root = vim.fs.find(".cjvim", { upward = true })
    if #root > 0 then
      root = root[1]
    else
      vim.notify("no session found")
      return
    end
  end
  vim.cmd("source " .. JoinPath(root, SESSION_VIM))
  loadWinBuffs(root)
  currentSession = root
end

---@param root string
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
      js[ct][winInfo.winnr] = {}
      local ctBuffs = js[ct][winInfo.winnr]

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
  local f = io.open(JoinPath(root, WIN_BUFFS), "w")
  if f ~= nil then
    f:write(json)
    f:close()
  end
end

function SaveSession()
  local root = currentSession or vim.fn.input("root: ", vim.fn.getcwd())
  if #root == 0 then
    return false
  end
  nvtree.close()
  if currentSession == nil then
    root = JoinPath(root, WS_DIR)
  end
  local dirExists = vim.fn.isdirectory(root)
  if dirExists == 0 then
    vim.fn.mkdir(root)
  end
  saveWinBuffs(root)
  vim.cmd("mks! " .. JoinPath(root, SESSION_VIM))
  saveProjectToHistory(root:sub(1, - #WS_DIR - 2))
  return true
end

SMap("n", ",p", pickProject)
SMap("n", "\\<F4>", function()
  if SaveSession() then
    vim.cmd("qa")
  end
end)
vim.api.nvim_create_user_command("LoadSession", function()
  LoadSession()
end, {})
