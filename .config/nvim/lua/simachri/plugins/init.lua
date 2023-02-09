return {
	"kyazdani42/nvim-web-devicons",

	-- Utils
	"tpope/vim-repeat",

	-- Terminal
	"voldikss/vim-floaterm",

	{
		{
			-- requires 'sudo pacman -S stylua'
			"ckipp01/stylua-nvim",
			ft = "lua",
		},
	},

	{
		"leafOfTree/vim-svelte-plugin",
		ft = { "svelte" },
	},

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

	"nvim-lua/popup.nvim",
	"nvim-lua/plenary.nvim",

	-- Rust
	"simrat39/rust-tools.nvim",

	{
		"L3MON4D3/LuaSnip",
		lazy = true,
	},

	"folke/which-key.nvim",

	{
		"lukas-reineke/indent-blankline.nvim",
		event = "VeryLazy",
		config = function()
			-- https://github.com/lukas-reineke/indent-blankline.nvim
			vim.g.indent_blankline_filetype_exclude =
				{ "markdown", "taskedit", "lspinfo", "packer", "checkhealth", "help", "" }
			vim.g.indent_blankline_show_first_indent_level = false
			require("indent_blankline").setup({
				char_highlight_list = {
					"IndentBlanklineIndent1",
				},
			})

			vim.cmd([[
                highlight IndentBlanklineIndent1 guifg=#eee8d5 gui=nocombine
            ]])
			-- This doesn't work:
			-- vim.api.nvim_set_hl(0, 'IndentBlanklineIndent1', { fg = '#586e75', nocombine = true })
		end,
	},
}
