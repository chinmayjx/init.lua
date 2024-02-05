require("nvim-autopairs").setup({})

require('Comment').setup({
  padding = true,
  sticky = true,
  ignore = nil,
  toggler = {
    line = ',/',
    block = ',?',
  },
  opleader = {
    line = ',/',
    block = ',?',
  },
})

vim.keymap.set('i', '<C-j>', 'copilot#Accept("")', {
  expr = true,
  replace_keycodes = false
})
vim.g.copilot_no_tab_map = true
SMap("i", "<M-C-j>", "<Plug>(copilot-accept-line)")
