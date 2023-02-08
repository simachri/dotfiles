return {
	"kyazdani42/nvim-web-devicons",

	-- Utils
	"tpope/vim-repeat",

	-- Terminal
	"voldikss/vim-floaterm",

	-- LSP
	"neovim/nvim-lspconfig",
	"onsails/lspkind-nvim",
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-nvim-lua",
	"hrsh7th/cmp-calc",
	"hrsh7th/cmp-cmdline",
	"saadparwaiz1/cmp_luasnip",
	"petertriho/cmp-git",
	"hrsh7th/cmp-nvim-lsp-signature-help",

	{
		{
			-- requires 'sudo pacman -S stylua'
			"ckipp01/stylua-nvim",
			ft = "lua",
		},
	},

	-- JS/TS
	"leafOfTree/vim-svelte-plugin",
	"jose-elias-alvarez/typescript.nvim",
	"jose-elias-alvarez/null-ls.nvim",

	-- Python
	{ "rafi/vim-venom", ft = { "python" } },

	-- TODO: Replace the formatter for python with a respective EFM configuration, see
	-- https://github.com/mattn/efm-langserver#configuration-for-neovim-builtin-lsp-with-nvim-lspconfig
	-- Formatter for HTML and Python
	"sbdchd/neoformat",
	{ "Chiel92/vim-autoformat", ft = { "python" } },

	"mbbill/undotree",
	"tpope/vim-surround",

	{
		"numToStr/Comment.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		keys = {
			{ "gcc" },
			{ "gbc" },
			{ "gc", mode = "v" },
			{ "gb", mode = "v" },
		},
		config = true,
	},

	-- Markdown
	"jakewvincent/mkdnflow.nvim",
	"ekickx/clipboard-image.nvim",
	{
		"iamcco/markdown-preview.nvim",
		build = "cd app && npm install",
		setup = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},

	"nvim-lua/popup.nvim",
	"nvim-lua/plenary.nvim",

	-- File navigation/marks
	"ThePrimeagen/harpoon",

	-- Golang
	"sebdah/vim-delve",
	"ray-x/go.nvim",
	"ray-x/guihua.lua", -- float term, codeaction and codelens gui support

	-- Rust
	"simrat39/rust-tools.nvim",

	-- Snippets
	"L3MON4D3/LuaSnip",

	"folke/which-key.nvim",

	-- Git
	"tpope/vim-fugitive",
	"sindrets/diffview.nvim",
	"lewis6991/gitsigns.nvim",

	{
		"glacambre/firenvim",
		build = function()
			vim.fn["firenvim#install"](0)
		end,
	},

	"lukas-reineke/indent-blankline.nvim",
}
