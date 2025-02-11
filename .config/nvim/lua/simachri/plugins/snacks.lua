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

		indent = { enabled = true },

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
			"<leader>fj",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>gt",
			function()
				Snacks.picker.grep({
					search = "- \\[ \\] ",
					live = false, -- easier filtering for returned list
					show_empty = true,
					format = "file",
					layout = {
						title = "Grep TODOs",
					},
				})
			end,
			desc = "Grep TODOs",
		},
		{
			-- DOES NOT YET WORK
			-- waiting for https://github.com/folke/snacks.nvim/discussions/509
			"<leader>fm",
			function()
				Snacks.picker.pick({
					finder = "proc",
					cmd = "fd",
					-- https://github.com/folke/snacks.nvim/blob/8edd7b4d866d77a2d7c8c7f58eacd97cb8bb1be4/lua/snacks/picker/source/files.lua#L13
					args = { "--type", "f", "--type", "l", "--color", "never", "-E", ".git", "-g", "*/Meetings/*" },
					transform = function(item)
						item.file = item.text
						-- item.dir = true
					end,
					layout = {
						title = "Find Meeting Notes",
					},
				})
			end,
			desc = "Find Meeting Notes",
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
							title = "List Directories",
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
	},
}
