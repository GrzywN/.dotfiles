local nnoremap = require('grzywn.keymap').nnoremap
local builtin = require('telescope.builtin')

require("telescope").load_extension("ui-select")

nnoremap('<leader>ff', '<cmd>Telescope find_files layout_strategy=vertical<cr>')
nnoremap('<leader>fg', builtin.git_files)
nnoremap('<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input('Grep > ' ) });
end)

