function SendToIpython()
  local current_window = vim.api.nvim_get_current_win()
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(0, 0, 99999, false)
  local cell = {}
  local tmp = {}
  local ix = current_line
  while ix >= 1 do
    if (string.match(lines[ix], "^%s*#%s*-*%s*$") ~= nil) then
      break
    end
    table.insert(tmp, lines[ix])
    ix = ix - 1
  end
  for i = #tmp, 1, -1 do
    table.insert(cell, tmp[i])
  end
  ix = current_line + 1
  while ix <= #lines do
    if (string.match(lines[ix], "^%s*#%s*-*%s*$") ~= nil) then
      break
    end
    table.insert(cell, lines[ix])
    ix = ix + 1
  end
  local windows = vim.api.nvim_tabpage_list_wins(0)
  local ipython_found = false
  for i = 1, #windows do
    local cbuf = vim.api.nvim_win_get_buf(windows[i])
    if (string.match(vim.api.nvim_buf_get_name(cbuf), "^term://.*:ipython") ~= nil) then
      ipython_found = true
      vim.api.nvim_set_current_win(windows[i])
      break
    end
  end
  if not ipython_found then
    print('ipython window not found')
    return
  end
  vim.cmd.startinsert()
  for i = 1, #cell do
    vim.api.nvim_feedkeys(cell[i] .. vim.api.nvim_replace_termcodes("<C-q><C-j>", true, true, true), 'n', false)
  end
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<escape><C-l><enter>", true, true, true), 'n', false)
  vim.defer_fn(function() vim.api.nvim_set_current_win(current_window) end, 100)
end

function OpenIpythonWindow(opts)
  local sp = opts.vertical and "vs" or "sp"
  local save_dir = vim.fn.getcwd()
  if opts.wd then
    vim.cmd.cd(opts.wd)
  end
  vim.cmd(sp .. " term://ipython --no-autoindent --TerminalInteractiveShell.editing_mode=emacs --profile=''")
  vim.cmd.cd(save_dir)
end

Map('n', "<leader>iv", function() OpenIpythonWindow({ vertical = true }) end)
Map('n', "<leader>ih", function() OpenIpythonWindow({}) end)
Map('n', "<leader>ii", SendToIpython)
