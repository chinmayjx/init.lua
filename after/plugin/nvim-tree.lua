vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
  },
  actions = {
    open_file = {
      window_picker = {
        enable = false
      }
    }
  },
  git = {
    ignore = false
  }
})

Map("n", "<leader>q", vim.cmd.NvimTreeToggle)
Map("n", "<C-q>", vim.cmd.NvimTreeOpen)
