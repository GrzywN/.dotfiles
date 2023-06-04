local nnoremap = require('grzywn.keymap').nnoremap
local builtin = require('telescope.builtin')

nnoremap('<leader>ff', '<cmd>Telescope find_files hidden=true<cr>')
nnoremap('<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input('Grep > ' ) });
end)
