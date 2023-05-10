local builtin = require('telescope.builtin')
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local themes = require "telescope.themes"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

Map('n', '<C-p>', builtin.find_files)
Map('n', '<M-p>', builtin.git_files)
Map('n', '<leader>t/', ":silent! lua require'telescope.builtin'.current_buffer_fuzzy_find()<CR>", {silent = true})
Map('n', '<leader>tt', builtin.builtin)
Map('n', '<leader>tr', builtin.resume)
Map('n', '<leader>tv', builtin.lsp_document_symbols)
Map('n', '<leader>tV', builtin.treesitter)
Map('n', '<leader>tu', builtin.lsp_references)
Map('n', '<leader>td', builtin.diagnostics)
Map('n', '<leader>tk', builtin.keymaps)
Map('n', '<leader>tp', builtin.commands)
Map('n', '<leader>to', builtin.oldfiles)
Map('n', '<leader>th', builtin.help_tags)

require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
      },
    },
    layout_config = {
      scroll_speed = 3
    }
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
