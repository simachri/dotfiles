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
		},

		-- https://cmp.saghen.dev/configuration/snippets.html#luasnip
		snippets = { preset = "luasnip" },

		-- https://cmp.saghen.dev/recipes.html#mini-icons
		completion = {
			menu = {
				border = "single",

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

			documentation = { window = { border = "single" } },

		},

		signature = { window = { border = "single" } },

	},
	opts_extend = { "sources.default" },
}
