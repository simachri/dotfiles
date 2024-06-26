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
			hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)

			require("ibl").setup({
				indent = { highlight = "IndentBlankLineChar" },
				scope = { enabled = false },
				exclude = {
					filetypes = {
						-- "markdown",
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
}
