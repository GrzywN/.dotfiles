local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local util = require "lspconfig/util"

-- :LspInfo
local servers = { 
  -- Lua
  "lua_ls",

  -- HTML
  "html", "htmx",

  -- CSS
  "cssls", "tailwindcss",

  -- JavaScript / TypeScript
  "tsserver",

  -- Frontend frameworks
  "astro", "volar", "vuels",

  -- PHP
  "intelephense", "pest_ls",

  -- Go
  "gopls",

  -- DevOps
  "terraform_lsp", "terraformls", "snyk_ls", "docker_compose_language_service", "bashls", "dockerls", "yamlls",

  -- Databases
  "prismals", 
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

-- Typescript
local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
  }
  vim.lsp.buf.execute_command(params)
end

lspconfig.tsserver.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  init_options = {
    disable_suggestions = true,
  },
  commands = {
    OrganizeImports = {
      organize_imports,
      description = "Organize Imports",
    },
  },
}

-- Golang
lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
    },
  },
}
