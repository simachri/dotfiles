return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	-- IMPORTANT: There is also an autocmd here /home/xi3k/.config/nvim/lua/simachri/autocmd.lua
	-- VimEnter is required to make the autocmd run. https://github.com/folke/todo-comments.nvim/issues/264#issuecomment-2254810084
	-- event = "VimEnter",
	ft = "markdown",
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
			WAIT = { icon = " ", color = "warning" },
			HACK = { icon = " ", color = "warning" },
			WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
			PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
			NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
			TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
		},
	},
	-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#todo_comments
	keys = {
		{
			"<leader>st",
			function()
				Snacks.picker.todo_comments()
			end,
			desc = "Todo",
		},
		{
			"<leader>sT",
			function()
				Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
			end,
			desc = "Todo/Fix/Fixme",
		},
	},
}
