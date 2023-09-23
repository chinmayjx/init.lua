local telescope = require("telescope")
local builtin = require('telescope.builtin')
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local themes = require("telescope.themes")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local trouble = require("trouble.providers.telescope")
local conf = require("telescope.config").values

local ignore_dirs = {
  'node_modules',
  '.venv',
  '.git',
  'dist',
  'target',
  '.cjvim',
  '__pycache__',
  '__mocks__',
}
local ignore_files = {
  '.sesh.vim'
}

local cmd = {
  "rg",
  "--files",
  "--follow",
  "--hidden",
  "--no-ignore-dot",
  "--no-ignore-exclude",
  "--no-ignore-global",
  "--no-ignore-vcs",
  "--no-ignore-parent"
}
for i = 1, #ignore_dirs do
  table.insert(cmd, "-g")
  table.insert(cmd, "!" .. ignore_dirs[i])
end
for i = 1, #ignore_files do
  table.insert(cmd, "-g")
  table.insert(cmd, "!" .. ignore_files[i])
end

local liveGrep = function(opts)
  opts = opts or {}
  local dopts = {
    grep_open_files = false,
    additional_args = {
      "--follow",
    }
  }
  dopts = vim.tbl_extend("force", dopts, opts)
  builtin.live_grep(dopts)
end

Map('n', '<C-p>', function() builtin.find_files({ find_command = cmd }) end)
Map('n', '<C-M-p>', function() builtin.find_files({ hidden = true, no_ignore = true, no_ignore_parent = true }) end)
Map('n', '<M-p>', builtin.git_files)
Map('n', '<leader>t/', function()
  builtin.current_buffer_fuzzy_find({ previewer = false })
end)
Map('n', '<leader>ts', function()
  builtin.live_grep({})
end)
Map('n', '<leader>tS', liveGrep)
Map('n', '<leader>tt', builtin.builtin)
Map('n', '<leader>tb', builtin.buffers)
Map('n', '<leader>tr', builtin.pickers)
Map('n', '<leader>tg', builtin.git_status)
Map('n', '<leader>tv', builtin.lsp_document_symbols)
Map('n', '<leader>tV', builtin.treesitter)
Map('n', '<leader>tu', builtin.lsp_references)
Map('n', '<leader>td', builtin.diagnostics)
Map('n', '<leader>tk', builtin.keymaps)
Map('n', '<leader>tp', builtin.commands)
Map('n', '<leader>to', builtin.oldfiles)
Map('n', '<leader>th', builtin.help_tags)

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<c-t>"] = trouble.open_with_trouble,
        ["<C-Down>"] = actions.cycle_history_next,
        ["<C-Up>"] = actions.cycle_history_prev,
      },
      n = {
        ["<c-t>"] = trouble.open_with_trouble,
      }
    },
    layout_config = {
      scroll_speed = 3
    },
    cache_picker = {
      num_pickers = 10,
      limit_entries = 100,
    }
  },
})


function SelectFromList(list, action)
  local p_window = require('telescope.pickers.window')
  local opts = themes.get_dropdown({
    layout_strategy = "center",
    layout_config = { width = 0.5, anchor = "N" },
    cache_picker = false
  })
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
        action(selection)
      end)
      return true
    end,

  }):find()
end

local function cmdSearchX()
  local cfg = {
    cmd = "rg --follow --files"
  }
  local showP
  showP = function()
    local opts = {
      finder = finders.new_oneshot_job({ "bash", "-c", cfg.cmd }, {}),
      sorter = conf.generic_sorter(),
      layout_strategy = "horizontal",
      -- layout_config = { width = 0.9, height = 0.9, anchor = "S" },
      cache_picker = false
    }
    pickers.new(opts, {
      prompt_title = cfg.cmd,
      attach_mappings = function(prompt_bufnr, map)
        map("i", "<C-e>", function()
          vim.ui.input({ prompt = "EditCMD: ", default = cfg.cmd, completion = "command" }, function(val)
            cfg.cmd = val
            showP()
          end)
        end)
        return true
      end
    }):find()
  end
  showP()
end

local function cmdSearch()
  local opts = {
    finder = finders.new_job(function(prompt)
      local c = {
        "bash",
        "-c",
        prompt
      }
      return c
    end),
    sorter = sorters.highlighter_only(),
    layout_strategy = "horizontal",
    -- layout_config = { width = 0.9, height = 0.9, anchor = "S" },
    cache_picker = false
  }
  pickers.new(opts, {
    prompt_title = "abcd",
    attach_mappings = function(prompt_bufnr, map)
      return true
    end
  }):find()
end

-- cmdSearch()

return {
  liveGrep = liveGrep
}
