vim.g.mapleader = ' '
vim.opt.clipboard = 'unnamedplus'
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = '120'
vim.opt.wrap = false
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-- Python specific settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.undofile = true
vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.updatetime = 0
vim.opt.cmdheight = 1
vim.opt.shortmess:append('c')
vim.opt.winborder = 'rounded'

vim.diagnostic.config({
  virtual_text = {
    prefix = '●',
    source = "if_many",
  },
  float = {
    source = "if_many",
    border = 'rounded',
  },
  signs = true,
  underline = true,
  update_in_insert = false,
})

local map = vim.keymap.set

map('n', '<leader>er', vim.diagnostic.open_float, { desc = 'Show diagnostic' })
map('n', '[d', vim.diagnostic.get_next, { desc = 'Previous diagnostic' })
map('n', ']d', vim.diagnostic.get_prev, { desc = 'Next diagnostic' })

map('v', 'J', ":m '>+1<CR>gv=gv")
map('v', 'K', ":m '<-2<CR>gv=gv")
map('n', 'J', 'mzJ`z')
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')
map('x', '<leader>p', [["_dP]])
map('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
map('n', '<leader><CR>', '<cmd>so<CR>')
map('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true })

vim.pack.add({
  { src = "https://github.com/catppuccin/nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/hrsh7th/nvim-cmp" },
  { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/williamboman/mason.nvim" },
  { src = "https://github.com/williamboman/mason-lspconfig.nvim" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/github/copilot.vim" },
  { src = "https://github.com/ThePrimeagen/harpoon" },
  { src = "https://github.com/Oldenborg/vim-px-to-rem" },
})

-- "https://github.com/catppuccin/nvim"
require('catppuccin').setup({
  flavour = "mocha",
  transparent_background = false,
})
vim.cmd.colorscheme('catppuccin-mocha')
vim.opt.background = 'dark'
vim.opt.termguicolors = true

-- "https://github.com/williamboman/mason.nvim"
require("mason").setup()

-- "https://github.com/williamboman/mason-lspconfig.nvim"
require('mason-lspconfig').setup({
  automatic_installation = true
})

-- "https://github.com/nvim-treesitter/nvim-treesitter"
require('nvim-treesitter.config').setup({
  highlight = { enable = true },
  ensure_installed = { "lua", "javascript", "typescript", "html", "css", "json", "python" }
})

map('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
map('n', 'K', vim.lsp.buf.hover, { desc = 'Hover' })
map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action' })
map('n', '<leader>gr', vim.lsp.buf.references, { desc = 'References' })
map('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })
map('n', '<F2>', vim.lsp.buf.rename, { desc = 'Rename' })
map('n', '<leader>fm', vim.lsp.buf.format, { desc = 'Format' })
map('n', 'gl', vim.diagnostic.open_float, { desc = 'Open diagnostic' })

-- LSP servers configuration
local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('lspconfig')

-- require('lspconfig').ts_ls.setup({
--   capabilities = capabilities,
--   filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" }
-- })
--
-- require('lspconfig').volar.setup({
--   capabilities = capabilities,
--   filetypes = { "vue" }
-- })
--
-- require('lspconfig').intelephense.setup({
--   capabilities = capabilities,
--   filetypes = { "php" }
-- })

vim.lsp.enable({ "lua_ls", "html", "cssls", "tailwindcss", "ts_ls", "astro", "vue_ls", "intelephense", "eslint" })

vim.lsp.enable({ "lua_ls", "html", "cssls", "tailwindcss", "ts_ls", "astro", "vue_ls", "intelephense", "eslint", "pyright" })

local cmp = require('cmp')
cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer' },
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = nil,
    ['<S-Tab>'] = nil,
  }),
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})

-- "https://github.com/nvim-telescope/telescope.nvim"
local builtin = require('telescope.builtin')

map('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
map('n', '<leader>fg', builtin.git_files, { desc = 'Git files' })
map('n', '<leader>ps', function()
  local query = vim.fn.input('Grep > ')
  if query ~= '' then
    builtin.grep_string({ search = query })
  end
end, { desc = 'Grep string' })

-- "https://github.com/stevearc/oil.nvim"
require("oil").setup({
  view_options = {
    show_hidden = true,
  },
  win_options = {
    wrap = false,
    signcolumn = "yes",
    number = true,
    relativenumber = true,
  },
})
map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- "https://github.com/ThePrimeagen/harpoon"
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

map("n", "<leader>a", mark.add_file)
map("n", "<C-e>", ui.toggle_quick_menu)

map("n", "<C-h>", function() ui.nav_file(1) end)
map("n", "<C-j>", function() ui.nav_file(2) end)
map("n", "<C-k>", function() ui.nav_file(3) end)
map("n", "<C-l>", function() ui.nav_file(4) end)

-- "https://github.com/Oldenborg/vim-px-to-rem"
map("n", '<leader>re', '<cmd>RemAll<CR>')
