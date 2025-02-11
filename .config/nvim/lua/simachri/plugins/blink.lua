return {
	"saghen/blink.cmp",

	dependencies = {
		"echasnovski/mini.icons",
		"L3MON4D3/LuaSnip",
		version = "v2.*",
	},

	version = "*",

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },

			-- https://cmp.saghen.dev/configuration/sources.html#provider-options
			providers = {
				lsp = {
                    -- show lsp first
					score_offset = 100000,
				},
				snippets = {
					-- show snippets second
					score_offset = 500,
				},
			},
		},

		-- https://cmp.saghen.dev/configuration/snippets.html#luasnip
		snippets = { preset = "luasnip" },

		-- https://cmp.saghen.dev/recipes.html#mini-icons
		completion = {
			menu = {
				border = "rounded",

				draw = {
					components = {
						kind_icon = {
							ellipsis = false,
							text = function(ctx)
								local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
								return kind_icon
							end,
							-- Optionally, you may also use the highlights from mini.icons
							highlight = function(ctx)
								local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
								return hl
							end,
						},
					},

					treesitter = { "lsp" },
				},
			},

			-- https://cmp.saghen.dev/configuration/completion.html#documentation
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
				window = { border = "rounded" },
			},
		},

		-- https://cmp.saghen.dev/configuration/signature.html
		signature = {
			enabled = true,
			window = {
				border = "rounded",
			},
		},
	},
	opts_extend = { "sources.default" },
}
