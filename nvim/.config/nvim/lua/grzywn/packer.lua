vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.4',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  use 'navarasu/onedark.nvim'

  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v1.x',
    requires = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' }, -- Required
      { 'williamboman/mason.nvim' }, -- Optional
      { 'williamboman/mason-lspconfig.nvim' }, -- Optional

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' }, -- Required
      { 'hrsh7th/cmp-nvim-lsp' }, -- Required
      { 'hrsh7th/cmp-path' }, -- Optional
      { 'saadparwaiz1/cmp_luasnip' }, -- Optional
      { 'hrsh7th/cmp-nvim-lua' }, -- Optional

      -- Snippets
      { 'L3MON4D3/LuaSnip' }, -- Required
      { 'rafamadriz/friendly-snippets' },
    }
  }
  use { 'mhartington/formatter.nvim' }

  use 'dart-lang/dart-vim-plugin'
  use 'thosakwe/vim-flutter'
  use 'RobertBrunhage/flutter-riverpod-snippets'
  use 'Neevash/awesome-flutter-snippets'

  use {
    'folke/trouble.nvim',
    requires = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('trouble').setup {}
    end
  }

  use 'prichrd/netrw.nvim'
  use 'ThePrimeagen/harpoon'

  use 'christoomey/vim-tmux-navigator'
  use 'Oldenborg/vim-px-to-rem'
  use { 'echasnovski/mini.comment', branch = 'stable' }
  use { 'echasnovski/mini.trailspace', branch = 'stable' }
end)
