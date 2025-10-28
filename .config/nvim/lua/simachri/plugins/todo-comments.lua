return {
	{
		"folke/todo-comments.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- IMPORTANT: There is also an autocmd for text-based files /home/xi3k/.config/nvim/lua/simachri/autocmd.lua
		-- ft = "markdown",
		opts = {
			-- keywords recognized as todo comments
			keywords = {
				FIX = {
					icon = " ", -- icon used for the sign, and in search results
					color = "error", -- can be a hex color, or a named color (see below)
					alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
					-- signs = false, -- configure signs for some keywords individually
				},
				TODO = { icon = " ", color = "info" },
				NEXT = { icon = " ", color = "error" },
				CONT = { icon = "➤ ", color = "hint" },
				PEND = { icon = " ", color = "warning", alt = { "WAIT", "PENDING" } },
				HACK = { icon = " ", color = "warning" },
				WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
				PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
				NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
				TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
			},
		},
		keys = {
			{
				"<leader>ft",
				function()
					Snacks.picker.pick({
						dirs = {
							"~/Notes",
						},
						source = "todo_comments",
						keywords = { "CONT", "NEXT", "TODO", "PENDING" },
						ft = "md",
						sort = {
							fields = {
                                "line", -- contains the matching keyword. this will sort CONT > NEXT > PENDING > TODO
                                "score:desc",
							},
						},
						matcher = {
							sort_empty = true,
							frecency = false,
							history_bonus = false,
							cwd_bonus = false,
						},
						-- Remove 'waiting' items that are not yet due.
						---@param item snacks.picker.finder.Item Item returned from the matcher
						transform = function(item)
							local remove_item_as_not_yet_due = false

							if not item.text then
								return item
							end

							if not string.match(item.text, "PENDING:") then
								return item
							end

							-- check if line contains a date
							local year, month, day = string.match(item.text, "`(%d%d%d%d)%-(%d%d)%-(%d%d)`")
							if not year then
								return item
							end

							year, month, day = tonumber(year), tonumber(month), tonumber(day)
							local now = os.date("*t")
							local today = os.time({ year = now.year, month = now.month, day = now.day })
							local due_date = os.time({ year = year, month = month, day = day })
							if due_date > today then
								return remove_item_as_not_yet_due
							end

							return item
						end,
						formatters = {
							file = {
								filename_only = true,
							},
						},
						layout = {
							preview = false,
						},
					})
				end,
				desc = "Find Todos",
			},

			-- {
			-- 	"<leader>fw",
			-- 	function()
			-- 		Snacks.picker.pick({
			-- 			dirs = {
			-- 				"~/Notes",
			-- 			},
			-- 			source = "todo_comments",
			-- 			keywords = { "PENDING" },
			-- 			ft = "md",
			-- 			sort = {
			-- 				fields = {
			-- 					"score:desc",
			-- 					"line", -- contains the matching keyword. this will sort NEXT > TODO > WAIT.
			-- 					-- "idx",
			-- 					-- "#text",
			-- 				},
			-- 			},
			-- 			matcher = {
			-- 				sort_empty = true,
			-- 				frecency = false, -- frecency bonus
			-- 				history_bonus = false, -- give more weight to chronological order
			-- 				cwd_bonus = false,
			-- 			},
			-- 			formatters = {
			-- 				file = {
			-- 					filename_only = true,
			-- 				},
			-- 			},
			-- 			layout = {
			-- 				preview = false,
			-- 			},
			-- 			-- layout = {
			-- 			-- 	preset = "default",
			-- 			-- 	layout = {
			-- 			-- 		-- all values are defaults except for the title
			-- 			-- 		-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#default
			-- 			-- 		box = "horizontal",
			-- 			-- 		width = 0.8,
			-- 			-- 		min_width = 120,
			-- 			-- 		height = 0.8,
			-- 			-- 		{
			-- 			-- 			box = "vertical",
			-- 			-- 			border = "rounded",
			-- 			-- 			title = "Pending ToDo's {live} {flags}",
			-- 			-- 			{ win = "input", height = 1, border = "bottom" },
			-- 			-- 			{ win = "list", border = "none" },
			-- 			-- 		},
			-- 			-- 		{ win = "preview", title = "{preview}", border = "rounded", width = 0.5 },
			-- 			-- 	},
			-- 			-- },
			-- 		})
			-- 	end,
			-- 	ft = "markdown",
			-- 	desc = "Find Waiting todos",
			-- },

			{
				"<leader>fT",
				function()
					Snacks.picker.pick({
						source = "todo_comments",
						sort = {
							fields = {
								"score:desc",
								"line", -- contains the matching keyword. this will sort CONT > NEXT > PENDING > TODO
								-- "idx",
								-- "#text",
							},
						},
						matcher = {
							sort_empty = true,
							frecency = false, -- frecency bonus
							history_bonus = false, -- give more weight to chronological order
							cwd_bonus = false,
						},
					})
				end,
				desc = "Find Codebase Todos",
			},
		},
	},
}
