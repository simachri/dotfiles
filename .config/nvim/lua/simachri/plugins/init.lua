return {
	"kyazdani42/nvim-web-devicons",

	-- Utils
	"tpope/vim-repeat",

	-- Terminal
	"voldikss/vim-floaterm",

	-- LSP
	"neovim/nvim-lspconfig",

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

	{
		"L3MON4D3/LuaSnip",
		lazy = true,
	},

	"folke/which-key.nvim",

	"lukas-reineke/indent-blankline.nvim",
}
