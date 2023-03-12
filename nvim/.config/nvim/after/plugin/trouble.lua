local nnoremap = require('grzywn.keymap').nnoremap
local setup = require("trouble").setup

nnoremap('<leader>er', '<cmd>TroubleToggle<cr>')

setup {
  height = 5
}
