local grpName = "LuaCJaucmd"
local grp = vim.api.nvim_create_augroup(grpName, {clear = true})
local callback = function (opts)

end
vim.api.nvim_create_autocmd({"BufEnter"}, {
  group = grpName,
  pattern = "*",
  callback = callback
})
