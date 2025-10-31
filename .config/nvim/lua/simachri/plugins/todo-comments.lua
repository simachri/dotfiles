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
						keywords = { "CONT", "NEXT", "TODO", "PEND", "PENDING" },
						ft = "md",
						matcher = {
							sort_empty = true,
							frecency = false,
							history_bonus = false,
							cwd_bonus = false,
						},
						-- Remove 'waiting' items that are not yet due.
						-- Add "prio" field to enable sorting
						---@param item snacks.picker.finder.Item Item returned from the matcher
						transform = function(item)
							if item.text and string.match(item.text, "PENDING:") then
								local y, m, d = string.match(item.text, "`(%d%d%d%d)%-(%d%d)%-(%d%d)`")
								if y then
									y, m, d = tonumber(y), tonumber(m), tonumber(d)
									local now = os.date("*t")
									local today = os.time({ year = now.year, month = now.month, day = now.day })
									local due = os.time({ year = y, month = m, day = d })
									if due > today then
										return nil
									end
								end
							end

							local tag = (item.tag or item.kind)
							if tag then
								tag = tag:upper()
							end
							if not tag and item.text then
								tag = item.text:match("(%u+)%s*:") or item.text:match("(%u+)")
							end

							local rank = { CONT = 1, NEXT = 2, PEND = 3, PENDING = 3, TODO = 4 }
							item.prio = rank[tag or ""] or 99

							return item
						end,
						-- sort = {
						-- 	fields = {
						-- 		"prio", -- new field, see transform function
						-- 		"score:desc", -- fuzzy, when search items are typed
						-- 	},
						-- },
						sort = function(left, right)
							local priority = { CONT = 1, NEXT = 2, PEND = 3, PENDING = 3, TODO = 4 }

							local function extract_tag(item)
								local tag = item.tag or item.kind
								if not tag and item.text then
									tag = item.text:match("(%u+)%s*:") or item.text:match("(%u+)")
								end
								if tag then
									tag = tag:upper()
								end
								return tag
							end

							local left_tag = extract_tag(left)
							local right_tag = extract_tag(right)

							local left_priority = priority[left_tag or ""] or 99
							local right_priority = priority[right_tag or ""] or 99

							if left_priority ~= right_priority then
								return left_priority < right_priority
							end

							local left_score = left.score or 0
							local right_score = right.score or 0
							if left_score ~= right_score then
								return left_score > right_score
							end

							local left_path = left.path or ""
							local right_path = right.path or ""
							if left_path ~= right_path then
								return left_path < right_path
							end

							local left_line = left.line or 0
							local right_line = right.line or 0
							if left_line ~= right_line then
								return left_line < right_line
							end

							local left_index = left.idx or 0
							local right_index = right.idx or 0
							return left_index < right_index
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
