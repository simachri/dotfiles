return {

	{
		"rafamadriz/friendly-snippets",
	},

	{
		"L3MON4D3/LuaSnip",
		dependencies = { "rafamadriz/friendly-snippets" },
		event = "InsertEnter",
		build = "make install_jsregexp",
		config = function()
			-- Examples from https://github.com/L3MON4D3/LuaSnip/blob/master/Examples/snippets.lua

			-- vim.api.nvim_set_keymap(
			-- 	"i",
			-- 	"<C-E>",
			-- 	"luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'",
			-- 	{ expr = true, silent = true }
			-- )
			local ls = require("luasnip")
			vim.keymap.set({ "i", "s" }, "<C-j>", function()
				ls.jump(1)
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-k>", function()
				ls.jump(-1)
			end, { silent = true })

			-- some shorthands...
			local s = ls.s
			--local sn = ls.sn
			local t = ls.t
			local i = ls.i
			local f = ls.f
			--local c = ls.c
			--local d = ls.d

			ls.config.set_config({
				-- history: If true, Snippets that were exited can still be jumped back into. As
				-- Snippets are not removed when their text is deleted, they have to be removed
				-- manually via LuasnipUnlinkCurrent.
				history = false,
				---- Update more often, :h events for more info.
				--updateevents = "TextChanged,TextChangedI",
				--ext_opts = {
				--[types.choiceNode] = {
				--active = {
				--virt_text = { { "choiceNode", "Comment" } },
				--},
				--},
				--},
				-- treesitter-hl has 100, use something higher (default is 200).
				ext_base_prio = 300,
				-- minimal increase in priority.
				ext_prio_increase = 1,
				-- enable_autosnippets = true,
			})
			-- Required for friendly-snippets to work.
			require("luasnip.loaders.from_vscode").lazy_load({
				exclude = { "markdown" },
			})

			require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets" })

			ls.add_snippets("all", {
				-- Checkbox Insert: "- [ ]", trigger is 'cb'.
				s({ trig = "ci", name = "Checkbox" }, {
					t({ "- [ ] " }),
					i(0),
				}),

				-- URL in the format [<URL name>](<URL>), trigger is 'url'.
				s({ trig = "url", name = "URL" }, {
					t({ "[" }),
					-- Placeholder with initial text.
					i(1, { "<link name>" }),
					t({ "](" }),
					f(function()
						return { vim.api.nvim_eval("@+") }
					end, {}),

					-- Last Placeholder, exit Point of the snippet. EVERY 'outer' SNIPPET NEEDS Placeholder 0.
					i(0),
					t({ ")" }),
				}),
			})
		end,
	},
}
