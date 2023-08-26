function Feedkeys(k)
  vim.api.nvim_feedkeys(k, 'n', false)
end

function ReplaceTermcodes(x)
  return vim.api.nvim_replace_termcodes(x, true, true, true)
end

function Map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

function SMap(mode, lhs, rhs, opts)
  local options = { silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  Map(mode, lhs, rhs, opts)
end

function BufDir()
  return vim.fs.dirname(vim.api.nvim_buf_get_name(0))
end

function JoinPath(...)
  local args = { ... }
  local p = table.concat(args, "/"):gsub("/+", "/")
  return p
end

---@param s string
---@param pat string
---@return table
function SplitString(s, pat)
  local res = {}
  local i = 1
  repeat
    local b, e = s:find(pat, i, false)
    if b == nil then
      break
    end
    table.insert(res, s:sub(i, b - 1))
    i = e + 1
  until i > #s
  table.insert(res, s:sub(i))
  return res
end
