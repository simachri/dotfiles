return {
	{
		"kyazdani42/nvim-web-devicons",
		event = "VeryLazy",
	},

	{
		"tpope/vim-repeat",
		event = "InsertEnter",
	},

	"voldikss/vim-floaterm",

	{
		"leafOfTree/vim-svelte-plugin",
		ft = { "svelte" },
	},

	{ "rafi/vim-venom", ft = { "python" } },

	{
		"sbdchd/neoformat",
		ft = { "python", "html", "lua", "svelte" },
	},

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
