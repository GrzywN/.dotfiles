require('catppuccin').load()

function configureColors(color)
  color = color or 'onedark'
  vim.cmd.colorscheme(color)
  vim.opt.background = 'dark'
  vim.opt.termguicolors = true
  
  -- vim.api.nvim_set_hl(0, 'Normal', { bg = 'none', })
  -- vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none', })
end

configureColors('catppuccin-mocha')
