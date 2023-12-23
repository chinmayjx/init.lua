local gs = require('gitsigns')
gs.setup({})

SMap("n", "<leader>gd", gs.diffthis)
SMap("n", "<leader>gb", gs.blame_line)
