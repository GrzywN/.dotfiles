local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.6',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-ui-select.nvim' }
    },
  },

  -- Theme
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

  -- Treesitter
  {"nvim-treesitter/nvim-treesitter"},

  -- LSP
  {
	  'VonHeikemen/lsp-zero.nvim',
	  branch = 'v3.x',
	  dependencies = {
      -- LSP Package management
		  {'williamboman/mason.nvim'},
		  {'williamboman/mason-lspconfig.nvim'},

		  -- LSP
		  {'neovim/nvim-lspconfig'},

		  -- Autocompletion
		  {'hrsh7th/cmp-nvim-lsp'},
		  {'hrsh7th/nvim-cmp'},

		  -- Snippets
		  {'L3MON4D3/LuaSnip'},
		  {'rafamadriz/friendly-snippets'},
	  }
  },

  -- TODO: add formatters none-ls, conform.nvim
  -- Formatter
  {'stevearc/conform.nvim'},

  -- Showing suggestions
  {
	  "folke/trouble.nvim",
	  dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Navigating files
  {
	  'prichrd/netrw.nvim',
	  dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {'ThePrimeagen/harpoon'},
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup {
        columns = { "icon" },
        view_options = {
          show_hidden = true,
        },
      }
    end,
  },

  -- Utility
  {'christoomey/vim-tmux-navigator'},
  {'Oldenborg/vim-px-to-rem'},

  -- AI
  --
  {'github/copilot.vim'},
})
