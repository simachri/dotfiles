return {
  -- Colorscheme
  {
    'ishan9299/nvim-solarized-lua',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
  },

  -- Statusline
  'famiu/feline.nvim',
  'kyazdani42/nvim-web-devicons',

  -- Utils
  'tpope/vim-repeat',

  -- Terminal
  'voldikss/vim-floaterm',

  -- LSP
  'neovim/nvim-lspconfig',
  'onsails/lspkind-nvim',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-nvim-lua',
  'hrsh7th/cmp-calc',
  'hrsh7th/cmp-cmdline',
  'saadparwaiz1/cmp_luasnip',
  'petertriho/cmp-git',
  'hrsh7th/cmp-nvim-lsp-signature-help',

  -- JS/TS
  'leafOfTree/vim-svelte-plugin',
  'jose-elias-alvarez/typescript.nvim',
  'jose-elias-alvarez/null-ls.nvim',

  -- Python
  { 'rafi/vim-venom', ft = {'python'} },

  -- Formatter for HTML and Python
  'sbdchd/neoformat',
  { 'Chiel92/vim-autoformat', ft = {'python'} },

  -- HTML
  'windwp/nvim-ts-autotag',

  'mbbill/undotree',
  'tpope/vim-surround',
  'numToStr/Comment.nvim',

  -- Markdown
  'jakewvincent/mkdnflow.nvim',
  'ekickx/clipboard-image.nvim',
  { "iamcco/markdown-preview.nvim", build = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, },

  'nvim-lua/popup.nvim',
  'nvim-lua/plenary.nvim',

  -- File navigation/marks
  'ThePrimeagen/harpoon',

  -- Session
  'rmagatti/auto-session',

  {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
  },
  'nvim-treesitter/playground',
  'nvim-treesitter/nvim-treesitter-textobjects',
  'nvim-treesitter/nvim-treesitter-context',

  -- Golang
  'sebdah/vim-delve',
  'ray-x/go.nvim',
  'ray-x/guihua.lua', -- float term, codeaction and codelens gui support

  -- Rust
  'simrat39/rust-tools.nvim',

  -- Snippets
  'L3MON4D3/LuaSnip',

  'folke/which-key.nvim',

  -- Git
  'tpope/vim-fugitive',
  'sindrets/diffview.nvim',
  'lewis6991/gitsigns.nvim',

  {
	  'glacambre/firenvim',
	  build = function() vim.fn['firenvim#install'](0) end
  },

  'lukas-reineke/indent-blankline.nvim',
}
