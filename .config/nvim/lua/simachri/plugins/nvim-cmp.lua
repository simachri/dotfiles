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
		event = { "InsertEnter", "CmdlineEnter" },
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			local has_words_before = function()
				unpack = unpack or table.unpack
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

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
                complete = {
                    completeopt = 'menu,menuone',
                },
				snippet = {
					expand = function(args)
						-- For `luasnip` user.
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = {
					["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
					["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
					-- -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
					["<C-n>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							if #cmp.get_entries() == 1 then
								cmp.confirm({ select = true })
							else
								cmp.select_next_item()
							end
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
							if #cmp.get_entries() == 1 then
								cmp.confirm({ select = true })
							end
						else
							fallback()
						end
					end, { "i", "s" }),
					-- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
					["<C-p>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
					["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
					["<C-e>"] = cmp.mapping(cmp.mapping.close(), { "i", "c" }),
					["<C-y>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							if luasnip.expandable() then
								luasnip.expand()
							else
								cmp.confirm({
									select = true,
								})
							end
						else
							fallback()
						end
					end),
					-- ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i" }),
					-- ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i" }),
					-- ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
					-- ["<C-e>"] = cmp.mapping(cmp.mapping.close(), { "i", "c" }),
					-- ["<C-y>"] = cmp.mapping(cmp.mapping.confirm({ select = true }), { "i" }),
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
					{
						name = "lazydev",
						group_index = 0, -- set group index to 0 to skip loading LuaLS completions
					},
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

			cmp.setup.filetype({ "markdown", "taskedit", "text" }, {
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

			cmp.setup.filetype({ "go", "java" }, {
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

			cmp.setup.filetype({ "typescript", "javascript" }, {
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
