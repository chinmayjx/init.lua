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
