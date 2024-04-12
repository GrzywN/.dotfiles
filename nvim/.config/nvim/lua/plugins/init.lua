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
        -- HTML
        "html-lsp",

        -- CSS
        "css-lsp", "tailwindcss-language-server",

        -- JavaScript / Typescript
        "typescript-language-server", "prettier", "eslint-lsp",

        -- Frontend frameworks
        "astro-language-server", "vetur-vls", "vue-language-server",

        -- PHP
        "intelephense", "pest-language-server", "pint",  "blade-formatter",

        -- Go
        "gopls", "goimports-reviser", "go-debug-adapter", "gomodifytags", "golines", "goimports", "gofumpt", "json-to-struct",

        -- DevOps
        "terraform-ls", "snyk", "docker-compose-language-service", "bash-language-server", "dockerfile-language-server", "yaml-language-server",

        -- Databases
        "prisma-language-server",
  		},
  	},
  },

  {
  	"nvim-treesitter/nvim-treesitter",
    highlight = { enable = true },
    indent = { enable = true },
  	opts = {
  		ensure_installed = {
        -- HTML
        "html", 

        -- CSS
        "css", "scss",

        -- JavaScript / Typescript
        "javascript", "typescript", "jsdoc",

        -- Flutter/Dart
        "dart",

        -- PHP
        "php", 

        -- Go
        "go", "gomod", "gosum", "gowork",

        -- DevOps
        "dockerfile", "terraform",

        -- Databases
        "prisma", "sql",

        -- Utility
        "markdown", "graphql",
  		},
  	},
  },
}
