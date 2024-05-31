vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoread = true

vim.opt.autoindent = true
vim.opt.smartindent = true

vim.o.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true

vim.opt.scrolloff = 4
vim.opt.signcolumn = "yes"
vim.o.completeopt = 'menuone,noselect'

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.timeout = false

vim.opt.mouse = "a"
vim.opt.ww = "<,>,[,],b,s"
vim.opt.wildignore = "*/node_modules/*,*/__pycache__/*"

vim.opt.guicursor = "n-v-c-ci-cr-sm:block,i-ve:ver25,r-o:hor20"

vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldnestmax = 10
vim.o.foldenable = false
