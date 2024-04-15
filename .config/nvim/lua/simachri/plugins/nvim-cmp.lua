return {

	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"onsails/lspkind-nvim",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-calc",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip",
			"petertriho/cmp-git",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"L3MON4D3/LuaSnip",
		},
		event = "InsertEnter",
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				window = {
					documentation = {
						border = "rounded",
						winhighlight = "FloatBorder:Pmenu",
					},
					completion = {
						border = "rounded",
						winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
					},
				},
				snippet = {
					expand = function(args)
						-- For `luasnip` user.
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = {
					-- Select first item automatically.
					completeopt = "menu,menuone,noinsert",
				},
				mapping = {
					["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
					["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
					["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i" }),
					["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i" }),
					["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
					["<C-e>"] = cmp.mapping(cmp.mapping.close(), { "i", "c" }),
					["<C-y>"] = cmp.mapping(cmp.mapping.confirm(), { "i", "c" }),
				},
				sources = {
					{ name = "luasnip", group_index = 1 },
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					-- https://github.com/hrsh7th/cmp-buffer
					{
						name = "buffer",
						keyword_length = 1, -- start completion after n chars.
						-- Also consider umlauts
						keyword_pattern = [[\k\+]],
						max_item_count = 6,
						option = {
							get_bufnrs = function()
								return vim.api.nvim_list_bufs()
							end,
						},
					},
					-- { name = 'path' },
					{ name = "git" },
				},
				formatting = {
					fields = { "abbr", "kind", "menu" },
					-- Show LSP icons from lspkind-nvim.
					--format = require("lspkind").cmp_format({with_text = false}),
					format = require("lspkind").cmp_format({
						with_text = false,
						menu = {
							buffer = "B",
							nvim_lsp = "LSP",
							luasnip = "Snip",
							nvim_lua = "Lua",
							-- cmp_tabnine = "TN",
						},
					}),
				},
				performance = {
					debounce = 60,
					throttle = 30,
					fetching_timeout = 500,
					async_budget = 1,
					max_view_entries = 200,
				},
			})

			cmp.setup.filetype("lua", {
				sources = cmp.config.sources({
					{ name = "nvim_lua" },
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					-- https://github.com/hrsh7th/cmp-buffer
					{
						name = "buffer",
						keyword_length = 1, -- start completion after n chars.
						-- Also consider umlauts
						keyword_pattern = [[\k\+]],
						max_item_count = 6,
						option = {
							get_bufnrs = function()
								return vim.api.nvim_list_bufs()
							end,
						},
					},
					{ name = "path" },
				}),
			})

			cmp.setup.filetype("markdown", {
				sources = cmp.config.sources({
					{ name = "luasnip", group_index = 1 },
					-- https://github.com/hrsh7th/cmp-buffer
					{
						name = "buffer",
						keyword_length = 1, -- start completion after n chars.
						-- Also consider umlauts
						keyword_pattern = [[\k\+]],
						max_item_count = 6,
						option = {
							get_bufnrs = function()
								return vim.api.nvim_list_bufs()
							end,
						},
					},
					{ name = "path" },
					{ name = "calc" },
				}),
			})

			cmp.setup.filetype("python", {
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					-- https://github.com/hrsh7th/cmp-buffer
					{
						name = "buffer",
						keyword_length = 1, -- start completion after n chars.
						-- Also consider umlauts
						keyword_pattern = [[\k\+]],
						max_item_count = 6,
						option = {
							get_bufnrs = function()
								return vim.api.nvim_list_bufs()
							end,
						},
					},
					{ name = "path" },
				}),
			})

			cmp.setup.filetype("go", {
				sources = cmp.config.sources({
					{ name = "luasnip", group_index = 1 },
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					-- https://github.com/hrsh7th/cmp-buffer
					{
						name = "buffer",
						keyword_length = 1, -- start completion after n chars.
						-- Also consider umlauts
						keyword_pattern = [[\k\+]],
						max_item_count = 6,
						option = {
							get_bufnrs = function()
								return vim.api.nvim_list_bufs()
							end,
						},
					},
					{ name = "path" },
				}),
			})

			cmp.setup.filetype("typescript, javascript", {
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					-- https://github.com/hrsh7th/cmp-buffer
					{
						name = "buffer",
						keyword_length = 1, -- start completion after n chars.
						-- Also consider umlauts
						keyword_pattern = [[\k\+]],
						max_item_count = 6,
						option = {
							get_bufnrs = function()
								return vim.api.nvim_list_bufs()
							end,
						},
					},
					{ name = "path" },
				}),
			})

			-- `/` cmdline setup.
			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- -- `:` cmdline setup.
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{
						name = "path",
						keyword_length = 3,
					},
				}, {
					{
						name = "cmdline",
						keyword_length = 3,
						option = {
							ignore_cmds = { "Man", "!" },
						},
					},
				}),
			})
		end,
	},

	{
		"hrsh7th/cmp-nvim-lsp",
		lazy = true,
	},
	{
		"hrsh7th/cmp-buffer",
		lazy = true,
	},
	{
		"hrsh7th/cmp-path",
		lazy = true,
	},
	{
		"hrsh7th/cmp-nvim-lua",
		lazy = true,
	},
	{
		"hrsh7th/cmp-calc",
		lazy = true,
	},
	{
		"hrsh7th/cmp-cmdline",
		lazy = true,
	},
	{
		"saadparwaiz1/cmp_luasnip",
		lazy = true,
	},
	{
		"petertriho/cmp-git",
		lazy = true,
		config = true,
	},
	{
		"hrsh7th/cmp-nvim-lsp-signature-help",
		lazy = true,
	},
}
