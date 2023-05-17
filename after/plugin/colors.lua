function TransparentTheme(opts)
  require(opts.module).setup({
    disable_background = true,
    transparent = true
  })
  vim.cmd.colorscheme(opts.theme)
  local groups = {
    'Normal', 'NormalNC', 'NormalFloat'
  }
  for i = 1, #groups do
    vim.api.nvim_set_hl(0, groups[i], { bg = "none" })
  end
end

TransparentTheme({ module = "nightfox", theme = "terafox" })
-- vim.cmd.colorscheme('sonokai')
