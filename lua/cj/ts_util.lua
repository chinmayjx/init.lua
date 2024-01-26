function CurrentFunction()
  local match = {
    ["function_definition"] = true,
    ["function_declaration"] = true
  }
  local node = vim.treesitter.get_node()
  while node ~= nil do
    local type = node:type()
    if match[type] then
      local name = node:field("name")[1]
      if name ~= nil then
        local x1, y1, x2, y2 = name:range()
        local line = vim.api.nvim_buf_get_lines(0, x1, x1+1, false)[1]:sub(y1, y2)
        print(line)
      end
      break
    end
    node = node:parent()
  end
end
