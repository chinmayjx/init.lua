vim.g.mapleader = " "
SMap("n", "<leader>sa", "gg0vG$")

SMap("n", "<leader>y", "\"+y")
SMap("v", "<leader>y", "\"+y")
SMap("n", ",,", ",")
SMap("n", ",q", ":qa<CR>")

-- Find & Replace
SMap("n", ",d", "*Ncgn")
SMap("n", ",h", ":%s//\\0/g<left><left><left><left><left>")
SMap("v", ",l", ":s//\\0/g<left><left><left><left><left>")
SMap("v", ",h", "\"hy:let @h=escape(@h,'\\/')<CR>:%s/\\M<C-r>h/\\0/g<left><left><space><backspace>")
SMap("v", ",D", "\"sy:let @/='\\V'.escape(@s, '\\')<CR>cgn")
SMap("v", "<leader>d", "y`]p")

-- Tab Management
SMap("n", "<F4><F4>", "gT")
SMap("n", "<F4>c", ":tabnew<CR>")
SMap("n", "<F4>x", ":tabc<CR>")

SMap("i", "<M-up>", "<C-o>gk")
SMap("i", "<M-down>", "<C-o>gj")
SMap("n", "<up>", "v:count == 0 ? 'gk' : 'k'", {expr = true})
SMap("n", "<down>", "v:count == 0 ? 'gj' : 'j'", {expr = true})

SMap({"n", "i"}, "<M-S-j>", function() vim.cmd.m("+1") end, {desc = "move line up"})
SMap({"n", "i"}, "<M-S-k>", function() vim.cmd.m("-2") end, {desc = "move line down"})
SMap("v", "<M-S-j>", ":m '>+1<CR>gv")
SMap("v", "<M-S-k>", ":m '<-2<CR>gv")

SMap("v", "<leader>(", "\"sdi(<C-r>s)")
SMap("v", "<leader>[", "\"sdi[<C-r>s]")
SMap("v", "<leader>{", "\"sdi{<C-r>s}")

SMap("i", "<C-Del>", "<C-o>dw")
SMap("i", "<C-h>", "<C-w>")
SMap("i", "<C-v>", "<C-r>\"")
SMap("i", "<M-z>", "<C-o>u")
SMap("i", "<M-Z>", "<C-o><C-r>")
SMap("i", "<Home>", "<C-o>^")
SMap("i", "<C-s>", "<C-o>:w<CR>")
SMap("n", "<C-s>", ":w<CR>")
SMap("n", ",x", ":bd<CR>")

SMap("n", "<leader>co", ":copen<CR>")
SMap("n", "<leader>cn", ":cnext<CR>")
SMap("n", "<leader>cp", ":cprev<CR>")

SMap("n", "<C-M-l>", function () vim.o.hlsearch = not vim.o.hlsearch end)
SMap("n", "<leader>li", ":lua print(vim.inspect())<left><left>")
SMap("n", "<leader>nw", ":setl nowrap<CR>")

SMap("n", "<F4>v", function()
  SelectFromList(vim.fn.CJClipboardItems(), vim.fn.CJpaste)
  vim.cmd.startinsert()
end)
SMap("n", "<leader>ss", ":lua SaveSession()<CR>")
SMap("i", "<F4>v", function()
  vim.g.CJIsInsert = 1
  SelectFromList(vim.fn.CJClipboardItems(), vim.fn.CJpaste)
  vim.cmd.startinsert()
end)
SMap("n", "<leader>ca", vim.lsp.buf.code_action)

SMap({ "n", "v" }, "\\y", "\"+y")
SMap({ "n", "v" }, "\\c", "\"_c")
SMap({ "n", "v" }, "\\d", "\"_d")
SMap("n", "\\x", function()
  local cb = vim.fn.winbufnr(0)
  local bi = vim.fn.getbufinfo(cb)[1]
  if bi.changed ~= 0 then
    vim.notify("unsaved changes")
    return
  end
  vim.cmd("b #")
  vim.cmd("bw " .. cb)
end)

SMap("n", "<M-[>0#01", vim.cmd.tabnext)
SMap("n", "<M-[>0#02", vim.cmd.tabprev)
