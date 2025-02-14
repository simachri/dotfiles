return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		dashboard = { enabled = false },
		explorer = { enabled = false },
		input = { enabled = true },

		scratch = {
			root = "/home/xi3k/Notes/Scratch",
			ft = "markdown",
            autowrite = false,
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

			-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#ivy
			layout = {
				preset = "default",
				layout = {
					-- 	position = "bottom",
					-- height = 0.7,
				},
				preview = false,
			},

			matcher = {
				frecency = true, -- frecency bonus
				history_bonus = true, -- give more weight to chronological order
				cwd_bonus = true,
			},

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
					},
				},

				list = {
					keys = {
						["<C-c>"] = { "close" },
					},
				},
			},
		},

		notifier = { enabled = false },
		quickfile = { enabled = true },
		scope = { enabled = false },
		scroll = { enabled = false },
		statuscolumn = { enabled = false },
		words = { enabled = false },
	},

	keys = {
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
			"<leader>ft",
			function()
				Snacks.picker.grep({
					search = "- \\[ \\] ",
					live = false, -- easier filtering for returned list
					show_empty = true,
					dirs = {
						"Meetings",
					},
					format = "file",
					layout = {
						layout = {
							preview = false,
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
									title = "TODOs {live} {flags}",
									{ win = "input", height = 1, border = "bottom" },
									{ win = "list", border = "none" },
								},
								{ win = "preview", title = "{preview}", border = "rounded", width = 0.5 },
							},
						},
					},
				})
			end,
			desc = "Find space meeting Todos",
		},

		-- {
		-- 	"<leader>fsj",
		-- 	function()
		-- 		Snacks.picker.files({
		-- 			exclude = {
		-- 				"Meetings",
		-- 				"Issues",
		-- 			},
		-- 			ft = "md",
		-- 			layout = {
		-- 				layout = {
		-- 					preview = false,
		-- 					layout = {
		-- 						-- all values are defaults except for the title
		-- 						-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#default
		-- 						box = "horizontal",
		-- 						width = 0.8,
		-- 						min_width = 120,
		-- 						height = 0.8,
		-- 						{
		-- 							box = "vertical",
		-- 							border = "rounded",
		-- 							title = "Space Files {live} {flags}",
		-- 							{ win = "input", height = 1, border = "bottom" },
		-- 							{ win = "list", border = "none" },
		-- 						},
		-- 						{ win = "preview", title = "{preview}", border = "rounded", width = 0.5 },
		-- 					},
		-- 				},
		-- 			},
		-- 		})
		-- 	end,
		-- 	desc = "Find Space Files",
		-- },

		{
			"<leader>ff",
			function()
				Snacks.picker.grep({
					search = "^tags:\\s*\\[.*?",
					exclude = {
						"Meetings",
						"Issues",
					},
                    live = false, -- will show all files with tags which then can be fuzzy searched in the result list
                    args = { "--max-count", "1" }, -- stop for each filter after 1 hit
					ft = "md",
					layout = {
                        preview = false,
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
									title = "Tagged Files {live} {flags}",
									{ win = "input", height = 1, border = "bottom" },
									{ win = "list", border = "none" },
								},
								{ win = "preview", title = "{preview}", border = "rounded", width = 0.5 },
							},
						},
					},
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
					},
					ft = "md",
					layout = {
						preview = true,
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
								title = "Meetings {live} {flags}",
								{ win = "input", height = 1, border = "bottom" },
								{ win = "list", border = "none" },
							},
							{ win = "preview", title = "{preview}", border = "rounded", width = 0.5 },
						},
					},
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
					},
					ft = "md",
					layout = {
						preview = true,
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
								title = "Issues {live} {flags}",
								{ win = "input", height = 1, border = "bottom" },
								{ win = "list", border = "none" },
							},
							{ win = "preview", title = "{preview}", border = "rounded", width = 0.5 },
						},
					},
				})
			end,
			desc = "Find Space Issues",
		},

		-- {
		-- 	"<leader>ld",
		-- 	function()
		-- 		Snacks.picker.pick({
		-- 			finder = "proc",
		-- 			cmd = "fd",
		-- 			-- https://github.com/folke/snacks.nvim/blob/8edd7b4d866d77a2d7c8c7f58eacd97cb8bb1be4/lua/snacks/picker/source/files.lua#L13
		-- 			args = { "--type", "d", "--type", "l", "--color", "never", "-E", ".git" },
		-- 			transform = function(item)
		-- 				item.file = item.text
		-- 				item.dir = true
		-- 			end,
		-- 			layout = {
		-- 				preset = "telescope",
		-- 				layout = {
		-- 					title = "Directories",
		-- 				},
		-- 			},
		-- 		})
		-- 	end,
		-- 	desc = "List Directories",
		-- },

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
								title = "Dotfiles {live} {flags}",
								{ win = "input", height = 1, border = "bottom" },
								{ win = "list", border = "none" },
							},
							{ win = "preview", title = "{preview}", border = "rounded", width = 0.5 },
						},
					},
				})
			end,
			desc = "Find Dotfiles",
		},

		{
			"<leader>/",
			function()
				Snacks.picker.lines({
					layout = {
						preview = true,
					},
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
					layout = {
						preview = true,
					},
				})
			end,
			desc = "Find Symbols",
		},

		{
			"<leader>gj",
			function()
				Snacks.picker.grep({
					layout = {
						preview = true,
					},
				})
			end,
			desc = "Grep",
		},

		{
			"<leader>fa",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "Find key mAppings",
		},
	},
}
