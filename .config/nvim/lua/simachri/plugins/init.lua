return {
	{
		"tpope/vim-repeat",
		event = "InsertEnter",
	},

	{
		"leafOfTree/vim-svelte-plugin",
		ft = { "svelte" },
	},

	{ "rafi/vim-venom", ft = { "python" } },

	{
		"mbbill/undotree",
		keys = {
			{ "<leader>u", ":UndotreeToggle<CR>", { silent = true } },
		},
	},

	{
		"tpope/vim-surround",
		event = "InsertEnter",
	},

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

	{
		"nvim-lua/popup.nvim",
		lazy = true,
	},
	{
		"nvim-lua/plenary.nvim",
		lazy = true,
	},

	{
		"simrat39/rust-tools.nvim",
		ft = { "rust" },
	},

	-- luals for neovim config
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Library items can be absolute paths
				-- "~/projects/my-awesome-lib",
				-- Or relative, which means they will be resolved as a plugin
				-- "LazyVim",
				-- When relative, you can also provide a path to the library in the plugin dir
				"nvim-dap-ui",
			},
		},
	},

	{
		"simachri/qol-md-extensions.nvim",
		dir = "~/Development/Neovim/simachri/qol-md-extensions.nvim",
		dev = true,
		ft = "markdown",
		lazy = true,
		opts = {},
		keys = {
			{
				"<leader>yc",
				":lua require('qol-md-extensions').convert_and_yank_buffer_to_wiki_markup()<CR>",
				desc = "Convert to wiki markup",
				noremap = true,
				silent = true,
			},
			{
				"<leader>yc",
				":lua require('qol-md-extensions').convert_and_yank_selection_to_wiki_markup()<CR>",
				mode = { "v" },
				desc = "Convert to wiki markup",
				noremap = true,
				silent = true,
			},
		},
	},
}
