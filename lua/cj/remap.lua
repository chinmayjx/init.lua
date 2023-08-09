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

vim.g.mapleader = " "
Map("n", "<leader>sa", "gg0vG$")

Map("n", "<leader>y", "\"+y")
Map("v", "<leader>y", "\"+y")
Map("n", ",,", ",")
Map("n", ",ee", function()
  local cb = vim.api.nvim_buf_get_number(0)
  vim.cmd("silent bufdo e")
  vim.api.nvim_win_set_buf(0, cb)
end)
Map("n", ",q", ":qa<CR>")
Map("n", ",d", "*Ncgn")
Map("n", ",h", ":%s//\\0/g<left><left><left><left><left>")
Map("v", ",l", ":s//\\0/g<left><left><left><left><left>")
Map("v", ",h", "\"hy:let @h=escape(@h,'\\/')<CR>:%s/\\M<C-r>h/\\0/g<left><left><space><backspace>")
Map("v", ",D", "\"sy:let @/='\\V'.escape(@s, '\\')<CR>cgn")
Map("v", "<leader>d", "y`]p")

Map("n", "t<F4>", "gT")
Map("n", "t<F5>", "<C-w>T")
Map("n", "<F4>c", ":tabnew<CR>")
Map("n", "<F4>x", ":tabc<CR>")

Map("i", "<M-up>", "<C-o>gk", { silent = true })
Map("i", "<M-down>", "<C-o>gj", { silent = true })
Map("n", "<up>", "gk")
Map("n", "<down>", "gj")

Map("n", "<C-S-down>", function() vim.cmd.m("+1") end)
Map("i", "<C-S-down>", "<Esc>:m .+1<CR>i")
Map("v", "<C-S-down>", ":m '>+1<CR>gv")
Map("n", "<C-S-up>", function() vim.cmd.m("-2") end)
Map("i", "<C-S-up>", "<Esc>:m .-2<CR>i")
Map("v", "<C-S-up>", ":m '<-2<CR>gv")

Map("v", "<leader>(", "\"sdi(<C-r>s)")
Map("v", "<leader>[", "\"sdi[<C-r>s]")
Map("v", "<leader>{", "\"sdi{<C-r>s}")

Map("i", "<C-Del>", "<C-o>dw")
Map("i", "<C-h>", "<C-w>")
Map("i", "<C-v>", "<C-r>\"")
Map("i", "<M-z>", "<C-o>u")
Map("i", "<M-Z>", "<C-o><C-r>")
Map("i", "<Home>", "<C-o>^")
Map("i", "<C-s>", "<C-o>:w<CR>")
Map("n", "<C-s>", ":w<CR>")
Map("n", "<C-S-right>", ":bn<CR>")
Map("n", "<C-S-left>", ":bp<CR>")
Map("n", ",x", ":bd<CR>")

Map("n", "<leader>co", ":copen<CR>")
Map("n", "<leader>cn", ":cnext<CR>")
Map("n", "<leader>cp", ":cprev<CR>")

Map("n", "<leader>li", ":lua print(vim.inspect())<left><left>")

Map("n", "<leader>;", ":15sp term://bash | startinsert<CR>")
Map("n", ",p", function() SelectFromList(vim.fn.CJGetProjects(), vim.fn.CJProjectSelect) end)
Map("n", "<enter>", function() SelectFromList(vim.fn.CJBuffs(), vim.fn.CJBuffSelect) end)
Map("n", "<F4>v", function()
  SelectFromList(vim.fn.CJClipboardItems(), vim.fn.CJpaste)
  vim.cmd.startinsert()
end)
Map("n", "<leader>ss", ":SaveSesh<CR>")
Map("i", "<F4>v", function()
  vim.g.CJIsInsert = 1
  SelectFromList(vim.fn.CJClipboardItems(), vim.fn.CJpaste)
  vim.cmd.startinsert()
end)
SMap("n", "<leader>ca", vim.lsp.buf.code_action)

vim.cmd [[
  nnoremap <expr> k (v:count > 1 ? "m'" . v:count : '') . 'k'
  nnoremap <expr> j (v:count > 1 ? "m'" . v:count : '') . 'j'
]]
