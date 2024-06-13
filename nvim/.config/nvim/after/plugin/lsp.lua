local lsp_zero = require('lsp-zero')

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local lsps = {
  -- Lua
  "lua_ls",

  -- HTML
  "html",

  -- CSS
  "cssls", "tailwindcss",

  -- JavaScript / TypeScript
  "tsserver",

  -- Frontend frameworks
  "astro", "volar",

  -- PHP
  "intelephense",
  -- "pest_ls",

  -- Go
  "gopls",

  -- Databases
  "sqlls", "prismals",
}

lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({ buffer = bufnr })

  local opts = { buffer = bufnr }

  -- vim.keymap.set({ 'n', 'x' }, '<leader>fm', function()
  --   vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
  --   print(123)
  -- end, opts)
end)

lsp_zero.set_sign_icons({
  error = '✘',
  warn = '▲',
  hint = '⚑',
  info = '»'
})

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = lsps,
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
    lua_ls = function()
      local lua_opts = lsp_zero.nvim_lua_ls()
      require('lspconfig').lua_ls.setup(lua_opts)
    end,
  }
})

require 'lspconfig'.tsserver.setup {
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = "/home/user/.config/nvim/node_modules/@vue/typescript-plugin",
        languages = { "javascript", "typescript", "vue" },
      },
    },
  },
  filetypes = {
    "javascript",
    "typescript",
    "vue",
  },
}

require 'lspconfig'.volar.setup {
  init_options = {
    typescript = {
      tsdk = '/home/user/.config/nvim/node_modules/typescript/lib'
    }
  },
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' }
}

lsp_zero.setup_servers({'dartls', force = true})

local cmp = require('cmp')
local cmp_action = lsp_zero.cmp_action()
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
  sources = {
    { name = 'path' },
    { name = 'nvim_lsp' },
    { name = 'luasnip', keyword_length = 2 },
    { name = 'buffer',  keyword_length = 3 },
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<Tab>'] = nil,
    ['<S-Tab>'] = nil,
  }),
})

-- local on_attach = function(_, bufnr)
-- 	local opts = { buffer = bufnr }
--
-- 	vim.keymap.set("n", "gd", function()
-- 		vim.lsp.buf.definition()
-- 	end, opts)
-- 	vim.keymap.set("n", "K", function()
-- 		vim.lsp.buf.hover()
-- 	end, opts)
-- 	vim.keymap.set("n", "<leader>e", function()
-- 		vim.diagnostic.open_float()
-- 	end, opts)
-- 	vim.keymap.set("n", "[d", function()
-- 		vim.diagnostic.goto_prev()
-- 	end, opts)
-- 	vim.keymap.set("n", "]d", function()
-- 		vim.diagnostic.goto_next()
-- 	end, opts)
-- 	vim.keymap.set("n", "<leader>ca", function()
-- 		vim.lsp.buf.code_action()
-- 	end, opts)
-- 	vim.keymap.set("n", "<leader>gr", function()
-- 		vim.lsp.buf.references()
-- 	end, opts)
-- 	vim.keymap.set("n", "<leader>rn", function()
-- 		vim.lsp.buf.rename()
-- 	end, opts)
-- 	vim.keymap.set({ "n", "i" }, "<C-b>", function()
-- 		vim.lsp.buf.inlay_hint(0, nil)
-- 	end, opts)
-- 	vim.keymap.set("i", "<C-h>", function()
-- 		vim.lsp.buf.signature_help()
-- 	end, opts)
-- 	vim.keymap.set("n", "<leader>dl", function()
-- 		vim.diagnostic.setqflist()
-- 	end, opts)
-- end
--
