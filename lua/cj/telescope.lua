local builtin = require('telescope.builtin')
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local themes = require "telescope.themes"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

vim.keymap.set('n', '<C-p>', builtin.find_files, { noremap = true })
vim.keymap.set('n', '<leader>th', builtin.oldfiles, { noremap = true })
vim.keymap.set('n', '<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, { noremap = true })
vim.keymap.set('n', '<leader>vh', builtin.help_tags, { noremap = true })

require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
      },
    },
  },
})

local conf = require("telescope.config").values

function SelectFromList(list, action)
  local p_window = require('telescope.pickers.window')
  local opts = themes.get_dropdown { layout_strategy = "center", layout_config = { width = 0.5, anchor = "N" } }
  print(vim.inspect(opts))
  pickers.new(opts, {
    prompt_title = "title",
    finder = finders.new_table {
      results = list
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        action(selection[1])
      end)
      return true
    end,

  }):find()
end
