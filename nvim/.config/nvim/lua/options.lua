require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

local tab_spaces = 2

-- Line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Indenting
vim.opt.tabstop = tab_spaces
vim.opt.softtabstop = tab_spaces
vim.opt.shiftwidth = tab_spaces

vim.opt.expandtab = true
vim.opt.smarttab = true

vim.opt.autoindent = true
vim.opt.smartindent = true

-- Clipboard
vim.opt.clipboard = 'unnamedplus'

-- Searching
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Wrapping
vim.opt.wrap = false

-- Better user experience
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
vim.opt.undofile = true

vim.opt.cmdheight = 1
vim.opt.updatetime = 0
vim.opt.shortmess:append('c')

vim.opt.colorcolumn = '120'

-- Leader key
vim.g.mapleader = ' '
