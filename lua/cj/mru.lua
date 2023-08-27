local grpName = "MRUaucmd"
local grp = vim.api.nvim_create_augroup(grpName, { clear = true })
local winBuffs = {}

local fileNameLI = function(nm)
  local home = vim.fs.normalize("~")
  nm = string.gsub(nm, home, "~")
  local fn = nm
  local pt = ""
  for i = #fn, 1, -1 do
    if nm:sub(i, i) == "/" then
      fn = string.sub(nm, i + 1)
      pt = string.sub(nm, 1, i - 1)
      break
    end
  end
  return fn .. ":" .. pt
end

local updateWinBuffs = function(opts)
  if vim.fn.win_gettype() ~= "" then
    return
  end
  local winId = vim.fn.win_getid()
  local bufId = vim.fn.winbufnr(vim.fn.win_getid())
  if not winBuffs[winId] then
    winBuffs[winId] = {}
  end
  local buffs = winBuffs[winId]
  if #buffs > 0 and buffs[1] == bufId then
    return
  end
  local newBuffs = { bufId }
  local st = { [bufId] = true }
  for i = 1, #buffs do
    if not st[buffs[i]] then
      st[buffs[i]] = true
      table.insert(newBuffs, buffs[i])
      if #newBuffs > 10 then
        break
      end
    end
  end
  winBuffs[winId] = newBuffs
end

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  group = grpName,
  pattern = "*",
  callback = updateWinBuffs
})

local showPicker = function()
  local winId = vim.fn.win_getid()
  local buffs = winBuffs[winId]

  local redirect = function()
    require("telescope.builtin").buffers()
  end

  if #buffs < 2 then
    return redirect()
  end

  local bis = {}
  local names = {}
  for i = 2, #buffs do
    if not buffs[i] then
      break
    end
    local res, mess = pcall(function()
      bis[i - 1] = vim.fn.getbufinfo(buffs[i])[1]
      local nm = bis[i - 1].name
      if #nm == 0 then
        nm = buffs[i] .. "/[anon]"
      end
      names[i - 1] = fileNameLI(nm)
    end)
    if not res then
      print("pickBuf:err:", buffs[i], mess)
      table.remove(buffs, i)
      if #buffs < 2 then
        return redirect()
      end
      i = i - 1
    end
  end
  SelectFromList(names, function(arg)
    vim.cmd("b " .. buffs[arg.index + 1])
  end)
end

SMap("n", "<enter>", showPicker)

return {
  getWinBuffs = function()
    return winBuffs
  end,
  setWinBuffs = function(x)
    winBuffs = x
  end,
  fileNameLI = fileNameLI
}
