local nnoremap = require('grzywn.keymap').nnoremap

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 48,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
})

nnoremap('<C-n>', '<cmd>NvimTreeToggle<CR><cmd>set nu<CR><cmd>set rnu<CR>')
