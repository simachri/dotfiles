return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = false },
		dashboard = { enabled = false },
		explorer = { enabled = false },
		input = { enabled = false },

		scratch = {
			root = "/home/xi3k/Notes/Scratch",
			ft = "markdown",
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
				preset = "ivy",
				position = "bottom",
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
		quickfile = { enabled = false },
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
			desc = "List Scratch Buffer",
		},

		{
			"<leader>fj",
			function()
				Snacks.picker.files({
					exclude = { "Meetings" },
				})
			end,
			desc = "Find Files",
		},

		{
			"<leader>fst",
			function()
				Snacks.picker.grep({
					search = "- \\[ \\] ",
					live = false, -- easier filtering for returned list
					show_empty = true,
					format = "file",
					layout = {
						preview = "main",
						layout = {
							title = "TODOs",
						},
					},
				})
			end,
			desc = "Find Space TODOs",
		},

		{
			"<leader>fsj",
			function()
				Snacks.picker.files({
					exclude = {
						"Meetings",
						"Issues",
					},
					ft = "md",
					layout = {
						layout = {
							title = "Files",
						},
					},
				})
			end,
			desc = "Find Space Files",
		},

		{
			"<leader>fsl",
			function()
				Snacks.picker.grep({
					search = "tags:\\s*\\n\\s*-.*",
					ft = "md",
					layout = {
						layout = {
							title = "Tagged Files",
						},
					},
					args = { "-U" }, -- --multline and -U are equivalent
				})
			end,
			desc = "Find Tagged Space Files",
		},

		{
			"<leader>fsm",
			function()
				Snacks.picker.files({
					dirs = {
						"Meetings",
					},
					ft = "md",
					layout = {
						layout = {
							title = "Meetings",
						},
					},
				})
			end,
			--          -- DOES NOT YET WORK
			--          -- waiting for https://github.com/folke/snacks.nvim/discussions/509
			-- function()
			-- 	Snacks.picker.pick({
			-- 		finder = "proc",
			-- 		cmd = "fd",
			-- 		-- https://github.com/folke/snacks.nvim/blob/8edd7b4d866d77a2d7c8c7f58eacd97cb8bb1be4/lua/snacks/picker/source/files.lua#L13
			-- 		args = { "--type", "f", "--type", "l", "--color", "never", "-E", ".git", "-g", "*/Meetings/*" },
			-- 		transform = function(item)
			-- 			item.file = item.text
			-- 			-- item.dir = true
			-- 		end,
			-- 		layout = {
			-- 			title = "Meeting Notes",
			-- 		},
			-- 	})
			-- end,
			desc = "Find Space Meeting Notes",
		},

		{
			"<leader>fsi",
			function()
				Snacks.picker.files({
					dirs = {
						"Issues",
					},
					ft = "md",
					layout = {
						layout = {
							title = "Issues",
						},
					},
				})
			end,
			--          -- DOES NOT YET WORK
			--          -- waiting for https://github.com/folke/snacks.nvim/discussions/509
			-- function()
			-- 	Snacks.picker.pick({
			-- 		finder = "proc",
			-- 		cmd = "fd",
			-- 		-- https://github.com/folke/snacks.nvim/blob/8edd7b4d866d77a2d7c8c7f58eacd97cb8bb1be4/lua/snacks/picker/source/files.lua#L13
			-- 		args = { "--type", "f", "--type", "l", "--color", "never", "-E", ".git", "-g", "*/Meetings/*" },
			-- 		transform = function(item)
			-- 			item.file = item.text
			-- 			-- item.dir = true
			-- 		end,
			-- 		layout = {
			-- 			title = "Meeting Notes",
			-- 		},
			-- 	})
			-- end,
			desc = "Find Space Issues",
		},

		{
			"<leader>ld",
			function()
				Snacks.picker.pick({
					finder = "proc",
					cmd = "fd",
					-- https://github.com/folke/snacks.nvim/blob/8edd7b4d866d77a2d7c8c7f58eacd97cb8bb1be4/lua/snacks/picker/source/files.lua#L13
					args = { "--type", "d", "--type", "l", "--color", "never", "-E", ".git" },
					transform = function(item)
						item.file = item.text
						item.dir = true
					end,
					layout = {
						preset = "select",
						layout = {
							title = "Directories",
						},
					},
				})
			end,
			desc = "List Directories",
		},

		{
			"<leader>lb",
			function()
				Snacks.picker.buffers({
					layout = {
						preset = "select",
					},
				})
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
					exclude = { "sessions", "plugged", "lain", "themes", "freedesktop", ".zprezto/" },
					layout = {
						preset = "select",
						title = "Dotfiles",
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
	},
}
