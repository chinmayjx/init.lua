require('trouble').setup({})
SMap('n', "<leader>xx", "<cmd>TroubleToggle<cr>")
SMap('n', "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>")
SMap('n', "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>")
