local nnoremap = require('grzywn.keymap').nnoremap
local vnoremap = require('grzywn.keymap').vnoremap
local xnoremap = require('grzywn.keymap').xnoremap

-- Open NetRW
nnoremap('<leader>pv', '<cmd>Ex<CR>')

-- Move lines
vnoremap('J', ":m '>+1<CR>gv=gv")
vnoremap('K', ":m '<-2<CR>gv=gv")

-- Stay in the same place when wrapping with J
nnoremap('J', 'mzJ`z')

-- Stay in the same place when moving (zz)
nnoremap('<C-d>', '<C-d>zz')
nnoremap('<C-u>', '<C-u>zz')
nnoremap('n', 'nzzzv')
nnoremap('N', 'Nzzzv')

-- Don't override buffer when pasting (and replacing something)
xnoremap('<leader>p', [["_dP]])

-- Format file based on LSP
nnoremap('<leader>fo', vim.lsp.buf.format)

-- Replace a word which you're on
nnoremap('<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Source config
nnoremap('<leader><CR>', '<cmd>so<CR>')

-- Make executable
nnoremap('<leader>x', '<cmd>!chmod +x %<CR>', { silent = true })
