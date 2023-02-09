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
					},
					completion = {
						border = "rounded",
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
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					-- https://github.com/hrsh7th/cmp-buffer
					{
						name = "buffer",
						keyword_length = 1, -- start completion after n chars.
						max_item_count = 10, -- show up to 10 items.
						option = {
							get_bufnrs = function()
								return vim.api.nvim_list_bufs()
							end,
						},
					},
					-- { name = 'path' },
					{ name = "git" },
					{ name = "luasnip" },
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
							cmp_tabnine = "TN",
						},
					}),
				},
			})

			vim.api.nvim_exec(
				[[
                  augroup cmp_aucmds
                    " Set up sources for filetypes.
                    autocmd FileType lua lua require'cmp'.setup.buffer {
                    \   sources = {
                    "\     { name = 'cmp_tabnine' },
                    \     { name = 'nvim_lua' },
                    \     { name = 'nvim_lsp' },
                    \     { name = 'nvim_lsp_signature_help' },
                    \     { name = 'buffer',
                    \       keyword_length = 1,
                    \       max_item_count = 5,
                    \       option = {
                    \         get_bufnrs = function()
                    \                       return vim.api.nvim_list_bufs()
                    \                     end
                    \       },
                    \     },
                    \     { name = 'path' },
                    \   },
                    \ }
                    autocmd FileType markdown lua require'cmp'.setup.buffer {
                    \   sources = {
                    \     { name = 'luasnip' },
                    \     { name = 'buffer',
                    \       keyword_length = 1,
                    \       max_item_count = 10,
                    \       option = {
                    \         get_bufnrs = function()
                    \                       return vim.api.nvim_list_bufs()
                    \                     end
                    \       },
                    \     },
                    \     { name = 'path' },
                    \     { name = 'calc' },
                    \   },
                    \ }
                    autocmd FileType python lua require'cmp'.setup.buffer {
                    \   sources = {
                    "\     { name = 'cmp_tabnine' },
                    \     { name = 'nvim_lsp' },
                    \     { name = 'nvim_lsp_signature_help' },
                    \     { name = 'buffer',
                    \       keyword_length = 1,
                    \       max_item_count = 5,
                    \       option = {
                    \         get_bufnrs = function()
                    \                       return vim.api.nvim_list_bufs()
                    \                     end
                    \       },
                    \     },
                    \     { name = 'path' },
                    \   },
                    \ }
                    autocmd FileType go lua require'cmp'.setup.buffer {
                    \   sources = {
                    "\     { name = 'cmp_tabnine' },
                    \     { name = 'nvim_lsp' },
                    \     { name = 'nvim_lsp_signature_help' },
                    \     { name = 'buffer',
                    \       keyword_length = 1,
                    \       max_item_count = 5,
                    \       option = {
                    \         get_bufnrs = function()
                    \                       return vim.api.nvim_list_bufs()
                    \                     end
                    \       },
                    \     },
                    \     { name = 'path' },
                    \   },
                    \ }
                    autocmd FileType typescript,javascript lua require'cmp'.setup.buffer {
                    \   sources = {
                    \     { name = 'nvim_lsp' },
                    \     { name = 'nvim_lsp_signature_help' },
                    "\     { name = 'cmp_tabnine' },
                    \     { name = 'buffer',
                    \       keyword_length = 1,
                    \       max_item_count = 5,
                    \       option = {
                    \         get_bufnrs = function()
                    \                       return vim.api.nvim_list_bufs()
                    \                     end
                    \       },
                    \     },
                    \     { name = 'path' },
                    \   },
                    \ }
                  augroup END
                ]],
				false
			)

			-- `/` cmdline setup.
			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- 2022-01-30: Disabled as it breaks the 'tab' behavior.
			-- -- `:` cmdline setup.
			-- cmp.setup.cmdline(':', {
			--   mapping = cmp.mapping.preset.cmdline(),
			--   sources = cmp.config.sources({
			--     {
			--         name = 'path',
			--         keyword_length = 3,
			--     }
			--   },
			--   {
			--     {
			--         name = 'cmdline',
			--         keyword_length = 3,
			--         option = {
			--             ignore_cmds = { 'Man', '!' }
			--         }
			--     }
			--   })
			-- })
		end,
	},
	{
		"onsails/lspkind-nvim",
		lazy = true,
		config = function()
			-- Do not display an icon for plain text in the buffer autocompletion used by nvim-cmp.
			require("lspkind").presets["default"]["Text"] = ""
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
