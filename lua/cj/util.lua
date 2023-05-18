function Feedkeys(k)
  vim.api.nvim_feedkeys(k, 'n', false)
end

function ReplaceTermcodes(x)
  return vim.api.nvim_replace_termcodes(x, true, true, true)
end

local function autoPair()
  local prs = {
    ["("] = ")",
    ["{"] = "}",
    ["["] = "]",
    ["\""] = "\"",
    ["'"] = "'",
    ["`"] = "`",
  }
  local function handleContext(x)
    local function _handle()
      if vim.treesitter.get_node():type() == 'string' then
        Feedkeys(x)
        return true
      end
      return false
    end

    local st, res = pcall(_handle)
    return st and res
  end

  local function enterOpenChar(o)
    if handleContext(o) then
      return
    end
    Feedkeys(o .. prs[o] .. ReplaceTermcodes('<left>'))
  end

  local function enterClosingChar(c)
    if handleContext(c) then
      return
    end
    local cur = vim.api.nvim_win_get_cursor(0)
    local line = vim.api.nvim_get_current_line()
    local nc = line:sub(cur[2] + 1, cur[2] + 1)
    if nc == c then
      cur[2] = cur[2] + 1
      vim.api.nvim_win_set_cursor(0, cur)
    else
      Feedkeys(c)
    end
  end

  local function enterRepeatChar(c)
    local st, inString = pcall(function() return vim.treesitter.get_node():type() == "string" end)
    if not st then
      inString = true
    end
    local cur = vim.api.nvim_win_get_cursor(0)
    local line = vim.api.nvim_get_current_line()
    local nc = line:sub(cur[2] + 1, cur[2] + 1)
    if nc == c then
      cur[2] = cur[2] + 1
      vim.api.nvim_win_set_cursor(0, cur)
    else
      if inString then
        Feedkeys(c)
      else
        Feedkeys(c .. c .. ReplaceTermcodes('<left>'))
      end
    end
  end

  local function backspace()
    if handleContext(ReplaceTermcodes("<backspace>")) then
      return
    end
    local cur = vim.api.nvim_win_get_cursor(0)
    local line = vim.api.nvim_get_current_line()
    local cc = line:sub(cur[2], cur[2])
    local nc = line:sub(cur[2] + 1, cur[2] + 1)
    if prs[cc] ~= nil and nc == prs[cc] then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<right><backspace><backspace>', true, true, true), 'n', false)
    else
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<backspace>', true, true, true), 'n', false)
    end
  end

  for o, c in pairs(prs) do
    if o == c then
      SMap('i', o, function() enterRepeatChar(o) end)
    else
      SMap('i', o, function() enterOpenChar(o) end)
      SMap('i', c, function() enterClosingChar(c) end)
    end
  end
  SMap('i', '<backspace>', backspace)
end

local function backspace()

end

autoPair()
