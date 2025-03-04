local gs = require('gitsigns')
gs.setup({
  diff_opts = {
    vertical = true,
  },
})

SMap("n", "<leader>gd", gs.diffthis)
SMap("n", "<leader>gb", gs.blame_line)
SMap("n", "<leader>gs", gs.stage_hunk)
SMap("n", "<leader>gu", gs.undo_stage_hunk)
SMap("n", "<leader>gr", gs.reset_hunk)
SMap("n", "<leader>gp", gs.preview_hunk)
SMap("n", "]h", gs.next_hunk)
SMap("n", "[h", gs.prev_hunk)
