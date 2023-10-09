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
		main = "ibl",
		config = function()
			local hooks = require("ibl.hooks")
			-- create the highlight groups in the highlight setup hook, so they are reset
			-- every time the colorscheme changes
			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				vim.api.nvim_set_hl(0, "IndentBlanklineChar", { fg = "#eee8d5" })
				vim.api.nvim_set_hl(0, "IblScope", { fg = "#eee8d5" })
			end)

			hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)

			require("ibl").setup({
				indent = { highlight = "IndentBlankLineChar" },
				scope = { enabled = false },
				exclude = {
					filetypes = {
						"markdown",
						"man",
						"gitcommit",
						"TelescopePrompt",
						"TelescopeResults",
						"help",
						"packer",
						"checkhealth",
						"lspinfo",
						"taskedit",
						"''",
					},
				},
			})
		end,
	},
}
