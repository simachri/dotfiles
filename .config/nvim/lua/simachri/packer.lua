vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Colorscheme
  use 'ishan9299/nvim-solarized-lua'

  -- Statusline
  use 'famiu/feline.nvim'
  use 'kyazdani42/nvim-web-devicons'

  -- Utils
  use 'tpope/vim-repeat'

  -- Terminal
  use 'voldikss/vim-floaterm'

  -- LSP
  use 'neovim/nvim-lspconfig'
  use 'onsails/lspkind-nvim'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-calc'
  use 'hrsh7th/cmp-cmdline'
  use 'saadparwaiz1/cmp_luasnip'
  use 'tzachar/fuzzy.nvim' -- requires 'nvim-telescope/telescope-fzf-native.nvim', see below
  use 'petertriho/cmp-git'
  use 'hrsh7th/cmp-nvim-lsp-signature-help'
  use 'zbirenbaum/copilot.lua'

  -- JS/TS
  use 'leafOfTree/vim-svelte-plugin'
  use 'jose-elias-alvarez/typescript.nvim'
  use 'jose-elias-alvarez/null-ls.nvim'

  -- Python
  use { 'rafi/vim-venom', ft = {'python'} }

  -- Formatter for HTML and Python
  use 'sbdchd/neoformat'
  use { 'Chiel92/vim-autoformat', ft = {'python'} }

  -- HTML
  use 'windwp/nvim-ts-autotag'

  use 'mbbill/undotree'
  use 'tpope/vim-surround'
  use 'numToStr/Comment.nvim'

  -- File manager
  use 'mcchrish/nnn.vim'

  use 'tweekmonster/startuptime.vim'

  -- Markdown
  use 'jakewvincent/mkdnflow.nvim'
  use 'ekickx/clipboard-image.nvim'
  use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })

  -- Debugging
  use 'mfussenegger/nvim-dap'
  use 'rcarriga/nvim-dap-ui'
  use 'theHamsta/nvim-dap-virtual-text'
  use 'nvim-telescope/telescope-dap.nvim'

  -- Telescope
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  -- Telescope
  use 'nvim-telescope/telescope.nvim'
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
  use 'nvim-telescope/telescope-ui-select.nvim'

  -- File navigation/marks
  use 'ThePrimeagen/harpoon'

  -- Session
  use 'rmagatti/auto-session'

  -- Treesitter
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'nvim-treesitter/playground'
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'nvim-treesitter/nvim-treesitter-context'

  use 'ThePrimeagen/refactoring.nvim'

  -- Golang
  use 'sebdah/vim-delve'
  use 'ray-x/go.nvim'
  use 'ray-x/guihua.lua' -- float term, codeaction and codelens gui support

  -- Rust
  use 'simrat39/rust-tools.nvim'

  -- Snippets
  use 'L3MON4D3/LuaSnip'

  use 'folke/which-key.nvim'

  -- Git
  use 'tpope/vim-fugitive'
  use 'sindrets/diffview.nvim'
  use 'lewis6991/gitsigns.nvim'

  use {
	  'glacambre/firenvim',
	  run = function() vim.fn['firenvim#install'](0) end 
  }

  use 'lukas-reineke/indent-blankline.nvim'
end)
