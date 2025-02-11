return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = false },
		dashboard = { enabled = false },
		explorer = { enabled = false },
		indent = { enabled = false },
		input = { enabled = false },

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
			"<leader>ft",
			function()
				Snacks.picker.grep({
					search = "- \\[ \\] ",
					live = true,
					show_empty = true,
					format = "file",
				})
			end,
			desc = "Find TODOs",
		},
		{
			-- does not work yet
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
				})
			end,
			desc = "List Directories",
		},
	},
}
