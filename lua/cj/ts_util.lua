function CurrentFunction()
  local match = {
    ["function_definition"] = true,
    ["function_declaration"] = true
  }
  local node = vim.treesitter.get_node()
  local _node = node

  local findName = function(nd)
    local type = nd:type()
    if match[type] then
      local name = nd:field("name")[1]
      if name ~= nil then
        local x1, y1, x2, y2 = name:range()
        local line = vim.api.nvim_buf_get_lines(0, x1, x1 + 1, false)[1]:sub(y1 + 1, y2)
        return line
      end
    end
  end

  while node ~= nil do
    local name = findName(node)
    if name then
      return name
    end
    node = node:parent()
  end
  node = _node
  while node ~= nil do
    local name = findName(node)
    if name then
      return name
    end
    if node:next_sibling() == nil then
      node = node:parent()
    else
      node = node:next_sibling()
    end
  end
end
