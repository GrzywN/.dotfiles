local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
    html = { { "prettierd", "prettier" } },
    css = { { "prettierd", "prettier" } },
    javascript = { { "prettierd", "prettier" } },
    go = { { "gofmt" }},
    prisma = { { "prisma-fmt", "prisma format"} },
  },

  format_on_save = {
    timeout_ms = 150,
    lsp_fallback = true,
  },
}

require("conform").setup(options)
