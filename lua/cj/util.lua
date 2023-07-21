function Feedkeys(k)
  vim.api.nvim_feedkeys(k, 'n', false)
end

function ReplaceTermcodes(x)
  return vim.api.nvim_replace_termcodes(x, true, true, true)
end

