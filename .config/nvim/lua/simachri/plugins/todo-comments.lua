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
				"<leader>lt",
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
						-- Remove 'waiting' items that are not yet due.
						---@param item snacks.picker.finder.Item Item returned from the matcher
						transform = function(item)
							local remove_item_as_not_yet_due = false

							-- special handling for PENDING, all others to be returned as-is
							if not string.match(item.line, "PENDING:") then
								return item
							end

							-- check if line contains a date
							local year, month, day = string.match(item.line, "`(%d%d%d%d)%-(%d%d)%-(%d%d)`")
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
						-- -- https://github.com/folke/todo-comments.nvim/blob/304a8d204ee787d2544d8bc23cd38d2f929e7cc5/lua/todo-comments/snacks.lua#L27
						-- ---@param item snacks.picker.Item
						-- ---@param picker snacks.Picker
						-- format = function(item, picker)
						-- 	local Config = require("todo-comments.config")
						-- 	local Highlight = require("todo-comments.highlight")
						--
						-- 	local a = Snacks.picker.util.align
						-- 	local _, _, kw = Highlight.match(item.text)
						-- 	local ret = {} ---@type snacks.picker.Highlights
						-- 	if kw then
						-- 		kw = Config.keywords[kw] or kw
						-- 		local icon = vim.tbl_get(Config.options.keywords, kw, "icon") or ""
						-- 		ret[#ret + 1] = { a(icon, 2), "TodoFg" .. kw }
						-- 		ret[#ret + 1] = { a(kw, 6, { align = "center" }), "TodoBg" .. kw }
						-- 		ret[#ret + 1] = { " " }
						-- 	end
						-- 	return vim.list_extend(ret, Snacks.picker.format.file(item, picker))
						-- end,
					})
				end,
				desc = "List Todos",
			},

			{
				"<leader>lw",
				function()
					Snacks.picker.pick({
						dirs = {
							"~/Notes",
						},
						source = "todo_comments",
						keywords = { "PENDING" },
						ft = "md",
						sort = {
							fields = {
								"score:desc",
								"line", -- contains the matching keyword. this will sort NEXT > TODO > WAIT.
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
						formatters = {
							file = {
								filename_only = true,
							},
						},
						layout = {
							preview = false,
						},
						-- layout = {
						-- 	preset = "default",
						-- 	layout = {
						-- 		-- all values are defaults except for the title
						-- 		-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#default
						-- 		box = "horizontal",
						-- 		width = 0.8,
						-- 		min_width = 120,
						-- 		height = 0.8,
						-- 		{
						-- 			box = "vertical",
						-- 			border = "rounded",
						-- 			title = "Pending ToDo's {live} {flags}",
						-- 			{ win = "input", height = 1, border = "bottom" },
						-- 			{ win = "list", border = "none" },
						-- 		},
						-- 		{ win = "preview", title = "{preview}", border = "rounded", width = 0.5 },
						-- 	},
						-- },
					})
				end,
				ft = "markdown",
				desc = "List Waiting todos",
			},

			{
				"<leader>lT",
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
				desc = "List Codebase Todos",
			},
		},
	},
}
