return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		input = { enabled = true },

		styles = {
			notification_history = {
				keys = {
					["<C-c>"] = "close",
				},
			},
		},

		scratch = {
			root = "/home/xi3k/Notes/Scratch",
			ft = "markdown",
			autowrite = true,
			win_by_ft = {
				markdown = {
					keys = {
						["Close"] = {
							"<C-c>",
							function()
								Snacks.scratch.open()
							end,
							desc = "Close",
							mode = { "n", "x" },
						},
						-- ["Purge"] = {
						-- 	"<C-w>p",
						-- 	function()
						-- 		local file = vim.fn.expand("%")
						-- 		if file ~= "" then
						-- 			vim.fn.delete(file)
						-- 		else
						-- 			print("No file to delete")
						-- 		end
						-- 	end,
						-- 	desc = "Purge",
						-- 	mode = { "n", "x" },
						-- },
					},
				},
			},
		},

		indent = {
			enabled = true,
			animate = {
				enabled = false,
			},
		},

		-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
		picker = {
			enabled = true,

			-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#default
			layout = {
				-- preset = "default",
				preview = true,
				layout = {
					box = "horizontal",
					-- width = 0.8,
					width = 0.95,
					min_width = 120,
					height = 0.8,
					{
						box = "vertical",
						border = "rounded",
						title = "{title} {live} {flags}",
						{ win = "input", height = 1, border = "bottom" },
						{ win = "list", border = "none" },
					},
					{
						win = "preview",
						title = "{preview}",
						border = "rounded",
						-- width = 0.5,
						width = 0.4,
					},
				},
			},

			matcher = {
				frecency = true, -- frecency bonus
				history_bonus = true, -- give more weight to chronological order
				cwd_bonus = true,
			},

			-- debug = {
			-- 	scores = true, -- show scores in the list
			-- },

			formatters = {
				file = {
					filename_first = true, -- display filename before the file path
					truncate = 80, -- truncate the file path to (roughly) this length
				},
			},

			win = {
				input = {
					keys = {
						["<Down>"] = { "history_forward", mode = { "i", "n" } },
						["<Up>"] = { "history_back", mode = { "i", "n" } },
						["<C-c>"] = { "close", mode = { "i", "n" } },
						-- ["<a-p>"] = { "toggle_preview", mode = { "i", "n" } },
						["<c-h>"] = { "toggle_preview", mode = { "i", "n" } },
					},
				},

				list = {
					keys = {
						["<C-c>"] = { "close" },
					},
				},
			},
		},

		notifier = {
			enabled = true,
		},
		quickfile = { enabled = true },

		dashboard = { enabled = false },
		explorer = { enabled = false },
		scope = { enabled = false },
		scroll = { enabled = false },
		statuscolumn = { enabled = false },
		words = { enabled = false },
	},

	keys = {
		{
			"<leader>sn",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "Show Notification history",
		},
		{
			"<leader>.",
			function()
				Snacks.scratch()
			end,
			desc = "Toggle Scratch Buffer",
		},
		{
			"<leader>ls",
			function()
				Snacks.scratch.select()
			end,
			desc = "List Scratch Buffers",
		},

		{
			"<leader>fj",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
		},

		{
			"<leader>ff",
			function()
				Snacks.picker.grep({
					-- layout = {
					-- 	preview = true,
					-- },
					search = "^tags:\\s*\\[.*?",
					exclude = {
						"Meetings",
						"Issues",
					},
					live = false, -- will show all files with tags which then can be fuzzy searched in the result list
					args = { "--max-count", "1" }, -- stop for each filter after 1 hit
					ft = "md",
				})
			end,
			desc = "Find tagged space Files",
		},

		{
			"<leader>fm",
			function()
				Snacks.picker.files({
					dirs = {
						"Meetings",
						"DSC/Meetings",
						"Deutsche_Bahn/Meetings",
                        "ECTR/Meetings",
                        "Hilti/Meetings",
						"Kaeser/Meetings",
						"Lifecycle_Graph/Meetings",
						"PDI/Meetings",
						"SAP/Meetings",
					},
					ft = "md",
					matcher = {
						sort_empty = true, -- sort results when the search string is empty
					},
					sort = {
						-- default sort is by score, text length and index
						fields = { "score:desc", "text:desc", "#text", "idx" },
					},
					-- layout = {
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
					-- 			title = "Meetings {live} {flags}",
					-- 			{ win = "input", height = 1, border = "bottom" },
					-- 			{ win = "list", border = "none" },
					-- 		},
					-- 		{ win = "preview", title = "{preview}", border = "rounded", width = 0.5 },
					-- 	},
					-- },
				})
			end,
			desc = "Find Space Meeting Notes",
		},

		{
			"<leader>fi",
			function()
				Snacks.picker.files({
					dirs = {
						"Issues",
						"DSC/Issues",
						"Deutsche_Bahn/Issues",
                        "ECTR/Issues",
                        "Hilti/Issues",
						"Kaeser/Issues",
						"Lifecycle_Graph/Issues",
						"PDI/Issues",
						"SAP/Issues",
					},
					ft = "md",
					-- layout = {
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
					-- 			title = "Issues {live} {flags}",
					-- 			{ win = "input", height = 1, border = "bottom" },
					-- 			{ win = "list", border = "none" },
					-- 		},
					-- 		{ win = "preview", title = "{preview}", border = "rounded", width = 0.5 },
					-- 	},
					-- },
				})
			end,
			desc = "Find Space Issues",
		},

		{
			"<leader>lb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "List Buffers",
		},

		{
			"<leader>fd",
			function()
				Snacks.picker.files({
					hidden = true,
					ignored = true,
					dirs = { "~/.config" },
					exclude = {
						"sessions",
						"plugged",
						"lain",
						"themes",
						"freedesktop",
						".zprezto/",
						"watson",
						"gup",
						"awesome",
						"himalaya",
						"TabNine",
						"yarn",
						"netlify",
					},
					-- layout = {
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
					-- 			title = "Dotfiles {live} {flags}",
					-- 			{ win = "input", height = 1, border = "bottom" },
					-- 			{ win = "list", border = "none" },
					-- 		},
					-- 		{ win = "preview", title = "{preview}", border = "rounded", width = 0.5 },
					-- 	},
					-- },
				})
			end,
			desc = "Find Dotfiles",
		},

		{
			"<leader>gwc",
			function()
				Snacks.picker.grep_word({
					layout = {
						layout = {
							-- all values are defaults except for the title
							-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#default
							box = "horizontal",
							width = 0.8,
							min_width = 120,
							height = 0.8,
							{
								box = "vertical",
								border = "rounded",
								title = "Grep Word in CWD {live} {flags}",
								{ win = "input", height = 1, border = "bottom" },
								{ win = "list", border = "none" },
							},
							{ win = "preview", title = "{preview}", border = "rounded", width = 0.5 },
						},
					},
				})
			end,
			desc = "Grep Word in CWD",
		},

		{
			"<leader>gwr",
			function()
				Snacks.picker.grep_word({
					cwd = vim.fn.expand("%:p:h"),
					-- layout = {
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
					-- 			title = "Grep Word Relative to current file {live} {flags}",
					-- 			{ win = "input", height = 1, border = "bottom" },
					-- 			{ win = "list", border = "none" },
					-- 		},
					-- 		{ win = "preview", title = "{preview}", border = "rounded", width = 0.5 },
					-- 	},
					-- },
				})
			end,
			desc = "Grep Word Relative to current file",
		},

		{
			"<leader>/",
			function()
				Snacks.picker.lines({
					-- layout = {
					-- 	preview = true,
					-- },
				})
			end,
			desc = "Grep Lines",
		},

		{
			"<leader>ggl",
			function()
				Snacks.picker.git_log()
			end,
			desc = "Grep Git Log",
		},

		{
			"<leader>fs",
			function()
				Snacks.picker.lsp_symbols({
					-- layout = {
					-- 	preview = true,
					-- },
				})
			end,
			desc = "LSP Find Symbols",
		},
		{
			"<leader>fS",
			function()
				Snacks.picker.lsp_workspace_symbols({
					-- layout = {
					-- 	preview = true,
					-- },
				})
			end,
			desc = "LSP Find Workspace Symbols",
		},
		{
			"gd",
			function()
				Snacks.picker.lsp_definitions({
					-- layout = {
					-- 	preview = true,
					-- },
				})
			end,
			desc = "Goto Definition",
		},
		{
			"gD",
			function()
				Snacks.picker.lsp_declarations({
					-- layout = {
					-- 	preview = true,
					-- },
				})
			end,
			desc = "Goto Declaration",
		},
		{
			"gr",
			function()
				Snacks.picker.lsp_references({
					-- layout = {
					-- 	preview = true,
					-- },
				})
			end,
			nowait = true,
			desc = "References",
		},
		{
			"gI",
			function()
				Snacks.picker.lsp_implementations({
					-- layout = {
					-- 	preview = true,
					-- },
				})
			end,
			desc = "Goto Implementation",
		},
		{
			"gy",
			function()
				Snacks.picker.lsp_type_definitions({
					-- layout = {
					-- 	preview = true,
					-- },
				})
			end,
			desc = "Goto T[y]pe Definition",
		},

		{
			"<leader>gj",
			function()
				Snacks.picker.grep({
					-- layout = {
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
					-- 			title = "Grep in CWD {live} {flags}",
					-- 			{ win = "input", height = 1, border = "bottom" },
					-- 			{ win = "list", border = "none" },
					-- 		},
					-- 		{ win = "preview", title = "{preview}", border = "rounded", width = 0.5 },
					-- 	},
					-- },
				})
			end,
			desc = "Grep in CWD",
		},

		{
			"<leader>gr",
			function()
				Snacks.picker.grep({
					cwd = vim.fn.expand("%:p:h"),
					-- layout = {
					-- 	preview = false,
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
					-- 			title = "Grep relative to current file {live} {flags}",
					-- 			{ win = "input", height = 1, border = "bottom" },
					-- 			{ win = "list", border = "none" },
					-- 		},
					-- 		{ win = "preview", title = "{preview}", border = "rounded", width = 0.5 },
					-- 	},
					-- },
				})
			end,
			desc = "Grep relative to current file",
		},

		{
			-- Find Help tags
			"<leader>fh",
			function()
				Snacks.picker.help()
			end,
			{ noremap = true, silent = true, desc = "Find Help tags" },
		},

		{
			"<leader>fa",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "Find key mAppings",
		},

		{
			"<leader>rs",
			function()
				Snacks.picker.resume()
			end,
			desc = "Resume Search",
		},
	},
}
