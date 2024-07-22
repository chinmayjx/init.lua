local function getNodeText(node)
  -- TODO: handle multi-line nodes
  local x1, y1, x2, y2 = node:range()
  local line = vim.api.nvim_buf_get_lines(0, x1, x1 + 1, false)[1]:sub(y1 + 1, y2)
  return line
end

function CurrentFunction(opts)
  opts = opts or {}
  local nameValidator = opts.nameValidator
  local match = {
    ["function_definition"] = true,
    ["function_declaration"] = true
  }
  local node = vim.treesitter.get_node()
  local _node = node

  local findName = function(nd)
    local type = nd:type()
    if match[type] then
      local nameNode = nd:field("name")[1]
      if nameNode ~= nil then
        local name = getNodeText(nameNode)
        if nameValidator and not nameValidator(name) then
          return
        end
        return name
      end
    end
  end

  while node ~= nil do
    local name = findName(node)
    if name then
      return name, node
    end
    node = node:parent()
  end
  node = _node

  while node ~= nil do
    local name = findName(node)
    if name then
      return name, node
    end
    if node:next_sibling() == nil then
      node = node:parent()
    else
      node = node:next_sibling()
    end
  end
end

function ContainingClass(opts)
  opts = opts or {}
  local node = opts.node or vim.treesitter.get_node()
  while node ~= nil do
    if node:type() == "class_definition" then
      local nameNode = node:field("name")[1]
      local name = getNodeText(nameNode)
      return name, node
    end
    node = node:parent()
  end
end
