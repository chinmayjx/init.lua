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
