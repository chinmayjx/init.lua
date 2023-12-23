---@param s string
---@return integer, integer
local function trailingNum(s)
  local n = 0
  local from = 1
  for i = 1, #s do
    local code = string.byte(s:sub(i,i))
    if code >= 48 and code <= 57 then
      n = n * 10
      n = n + code - 48
    else
      n = 0
      from = i + 1
    end
  end
  return from, n
end

local function nextFileNo()
	local baseName = vim.fn.expand("%:t:r")
  local extension = vim.fn.expand("%:e")
  local from, n = trailingNum(baseName)
  local newName = baseName:sub(1, from-1) .. (n + 1) .. "." .. extension
  vim.cmd.e(newName)
end

local function closeUselessBuffers()
  local last = vim.fn.bufnr("$")
  local prefixes = {"gitsigns:"}
  for i = 1, last do
    if vim.fn.bufexists(i) == 1 then
      local bInfo = vim.fn.getbufinfo(i)[1]
      local bName = bInfo.name
      local isFTerm = bInfo.variables.term_title ~= nil and bInfo.variables.cj_protected == nil
      local emptyUntouched = bInfo.name == "" and bInfo.changed == 0
      local ignorePrefix = false

      for _, p in pairs(prefixes) do
        local l = string.len(p)
        if bName:sub(1,l) == p then
          ignorePrefix = true
          break
        end
      end

      if isFTerm or emptyUntouched or ignorePrefix then
        vim.cmd("silent! bd! " .. i)
      end
    end
  end
end

local termBid = nil
local termHeight = 20
local function toggleTerm()
  local create = function ()
    vim.cmd(termHeight .. "sp term://bash | startinsert")
    local bInfo = vim.fn.getbufinfo(vim.fn.winbufnr(0))[1]
    vim.b.cj_protected = 1
    termBid = bInfo.bufnr
  end
  if not termBid then
    create()
  else
    local bInfo = vim.fn.getbufinfo(termBid)[1]
    if not bInfo then
      create()
      return
    end
    local window = bInfo.windows[1]
    if window == nil then
      vim.cmd(termHeight .. "sp | b " .. bInfo.bufnr .. " | startinsert")
    else
      local winNr = vim.fn.win_id2win(window)
      vim.cmd(winNr .. " wincmd c")
    end
  end
 end

SMap("t", "<M-[>0#00", toggleTerm)
SMap("n", "<M-[>0#00", toggleTerm)
SMap("n", ",kk", closeUselessBuffers)
SMap("n", "\\ne", vim.cmd.enew)
SMap("n", "\\nn", nextFileNo)
