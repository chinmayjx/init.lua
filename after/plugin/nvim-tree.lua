vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local defaultWidth = 30
local nvtree = require('nvim-tree')
local api = require('nvim-tree.api')
local tree = api.tree
local View = require('nvim-tree.view').View
local cj_telescope = require("cj.telescope")

local function grepInDir(dir)
  local pth = tree.get_node_under_cursor().absolute_path
  if pth == nil then
    return
  end
  if vim.fn.isdirectory(pth) == 0 then
    pth = vim.fs.dirname(pth)
  end
  cj_telescope.liveGrep({
    cwd = pth,
    grep_open_files = false,
    additional_args = {
      "--follow",
    }
  })
end

nvtree.setup({
  on_attach = function(bufnr)
    api.config.mappings.default_on_attach(bufnr)
    local map = function(mode, lhs, rhs)
      SMap(mode, lhs, rhs, { buffer = bufnr, nowait = true })
    end
    map("n", "<leader>s", grepInDir)
  end,
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
local WidthToggle = function()
  local cw = View.width
  if cw == defaultWidth then
    View.width = cw * 2
    tree.toggle()
    tree.toggle()
  else
    View.width = cw / 2
    tree.toggle()
    tree.toggle()
  end
end

Map("n", "<leader>qq", function() tree.toggle({ path = vim.fn.getcwd() }) end)
Map("n", "<leader>qc", function() tree.open({ find_file = true, update_root = true }) end)
Map("n", "<C-q>", vim.cmd.NvimTreeOpen)
Map("n", "<leader>qw", WidthToggle)
