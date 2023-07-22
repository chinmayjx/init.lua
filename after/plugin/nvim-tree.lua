vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local defaultWidth = 30
local nvtree = require('nvim-tree')
nvtree.setup({
  sort_by = "case_sensitive",
  view = {
    width = defaultWidth,
    side = 'right',
    -- preserve_window_proportions = true,
  },
  actions = {
    open_file = {
      -- resize_window = false,
      window_picker = {
        enable = false
      }
    }
  },
  git = {
    ignore = false
  }
})
local api = require('nvim-tree.api')
local View = require('nvim-tree.view').View
local WidthToggle = function()
  local cw = View.width
  if cw == defaultWidth then
    View.width = cw * 2
    api.tree.toggle()
    api.tree.toggle()
  else
    View.width = cw / 2
    api.tree.toggle()
    api.tree.toggle()
  end
end

Map("n", "<leader>qq", vim.cmd.NvimTreeToggle)
Map("n", "<leader>qc", function() api.tree.open({ find_file = true }) end)
Map("n", "<C-q>", vim.cmd.NvimTreeOpen)
Map("n", "<leader>qw", WidthToggle)
