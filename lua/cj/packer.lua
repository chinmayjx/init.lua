vim.cmd [[packadd packer.nvim]]
return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'nvim-telescope/telescope.nvim'
  use 'nvim-lua/plenary.nvim'
  use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
  use {
    "folke/trouble.nvim",
    requires = "nvim-tree/nvim-web-devicons",
  }
  use 'lewis6991/gitsigns.nvim'
  use { 'neovim/nvim-lspconfig' }
  use {
    "williamboman/mason.nvim",
    run = ":MasonUpdate"
  }
  use { 'williamboman/mason-lspconfig.nvim' }
  -- editing
  use "windwp/nvim-autopairs"
  use "nvim-treesitter/nvim-treesitter-context"
  use 'numToStr/Comment.nvim'

  -- nvim-cmp
  use { 'hrsh7th/nvim-cmp' }
  use { 'hrsh7th/cmp-nvim-lsp' }
  use { 'hrsh7th/cmp-buffer' }
  use { 'hrsh7th/cmp-path' }
  use { 'hrsh7th/cmp-cmdline' }
  use { 'saadparwaiz1/cmp_luasnip' }

  use { 'L3MON4D3/LuaSnip' }
  use { 'mhartington/formatter.nvim' }
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional
    },
  }
  -- Themes
  use "EdenEast/nightfox.nvim"
end)
