local nnoremap = require('grzywn.keymap').nnoremap
local builtin = require('telescope.builtin')

nnoremap('<leader>ff', builtin.find_files)
nnoremap('<leader>fg', builtin.git_files)
nnoremap('<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input('Grep > ' ) });
end)
