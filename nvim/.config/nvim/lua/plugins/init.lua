return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre' -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  {
  	"williamboman/mason.nvim",
  	opts = {
  		ensure_installed = {
        -- Lua
        "lua-language-server", "stylua", "luacheck",

        -- HTML
        "html-lsp",

        -- CSS
        "css-lsp", "unocss-language-server", "cssmodules-language-server", "css-variables-language-server", "tailwindcss-language-server",

        -- JavaScript / Typescript
        "typescript-langauge-server", "prettier", "eslint-lsp",

        -- JSON
        "jsonlint", "json-lsp",

        -- Frontend frameworks
        "angular-language-server", "astro-language-server", "vetur-vls", "vue-language-server",

        -- C
        "clangd",

        -- Python
        "autopep8",

        -- PHP
        "intelephense", "pest-language-server", "pint",  "blade-formatter",

        -- Go
        "gopls", "goimports-reviser", "go-debug-adapter", "gomodifytags", "golines", "goimports", "gofumpt", "json-to-struct",

        -- DevOps
        "terraform-ls", "snyk", "docker-compose-language-service", "bash-language-server", "dockerfile-language-server", "yaml-language-server",

        -- Databases
        "sqls",
        "sqlfmt",
        "prisma-language-server",
        "sql-formatter",
  		},
  	},
  },

  {
  	"nvim-treesitter/nvim-treesitter",
  	opts = {
  		ensure_installed = {
  			"vim", "lua", "vimdoc", "html", "css"
  		},
  	},
  },
}
