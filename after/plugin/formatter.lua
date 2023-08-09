-- Utilities for creating configurations
local util = require("formatter.util")
local filetypes = require("formatter.filetypes")
-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup {
  logging = true,
  log_level = vim.log.levels.WARN,
  filetype = {
    python = {
      filetypes.python.autopep8
    },
    javascriptreact = {
      filetypes.javascriptreact.prettier
    },
    typescript = {
      filetypes.typescript.prettier
    },
    scss = {
      filetypes.css.prettier
    },
    css = {
      filetypes.css.prettier
    },
    ["*"] = {
      filetypes.any.remove_trailing_whitespace
    }
  }
}
