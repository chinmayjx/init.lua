vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
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
Map("n", "<leader>qq", vim.cmd.NvimTreeToggle)
Map("n", "<leader>qc", function() api.tree.open({ find_file = true }) end)
Map("n", "<C-q>", vim.cmd.NvimTreeOpen)
