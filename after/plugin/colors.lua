function TransparentTheme(opts)
  require(opts.module).setup({
    disable_background = true,
    transparent_background = true,
    transparent = true
  })
  vim.cmd.colorscheme(opts.theme)
  local groups = {
    'Normal',
    'NormalNC',
    'NormalFloat',
    'LineNr',
    'SignColumn',
    'TelescopeNormal',
    'TelescopeBorder',
    'TelescopePromptNormal',
    'DiagnosticVirtualTextError',
    'DiagnosticVirtualTextWarn',
    'DiagnosticVirtualTextHint',
    'DiagnosticVirtualTextInfo'
  }
  for i = 1, #groups do
    local x = vim.api.nvim_get_hl(0, { name = groups[i] })
    vim.api.nvim_set_hl(0, groups[i], vim.tbl_extend("force", x, { bg = "none" }))
  end
end

-- TransparentTheme({ module = "nightfox", theme = "nordfox" })
TransparentTheme({ module = "catppuccin", theme = "catppuccin-frappe" })
