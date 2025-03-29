local function calculate_dirs(dir_type)
	local cwd = vim.fn.getcwd()
	local base_dirs = { "/home/xi3k/Notes", "/home/xi3k/Notes/Projects", "/home/xi3k/Notes/Wiki" }
	local project_dirs = {
		"DSC",
		"Deutsche_Bahn",
		"ECTR",
		"Hilti",
		"Kaeser",
		"Lifecycle_Graph",
		"PDI",
		"SAP",
	}

	for _, base in ipairs(base_dirs) do
		if cwd == base then
			local paths = {}
			for _, project in ipairs(project_dirs) do
				table.insert(paths, string.format("/home/xi3k/Notes/Projects/%s/%s", project, dir_type))
			end
			return paths
		end
	end

	return { dir_type }
end

local function calculate_meeting_dirs()
	return calculate_dirs("Meetings")
end

local function calculate_issues_dirs()
	return calculate_dirs("Issues")
end

local function calculate_wiki_dirs()
	local cwd = vim.fn.getcwd()
	local wiki_base = "/home/xi3k/Notes"

	local paths = { wiki_base }

	if cwd ~= wiki_base then
		table.insert(paths, cwd)
	end

	return paths
end

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
			scratch = {
				-- width = 100,
				-- height = 30,
				width = 0.9,
				height = 0.8,
				keys = {
					["<C-c>"] = "close",
				},
				wo = {
					winhighlight = "NormalFloat:Normal",
					wrap = true,
				},
			},
		},

		scratch = {
			root = "/home/xi3k/Notes/Scratch",
			ft = "markdown",
			autowrite = true,
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

			-- use the Snacks picker for selects such as code_actions
			ui_select = true,
			layouts = {
				select = {
					layout = {
						relative = "cursor",
						width = 70,
						min_width = 0,
						row = 1,
					},
				},
			},

			-- NOTE: If a layout is set here, using "preset = 'foo'" does not work in the
			-- pickers anymore.
			-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#default
			-- layout = {
			-- 	-- preset = "default",
			-- 	preview = true,
			-- 	layout = {
			-- 		box = "horizontal",
			-- 		-- width = 0.8,
			-- 		width = 0.95,
			-- 		min_width = 120,
			-- 		height = 0.8,
			-- 		{
			-- 			box = "vertical",
			-- 			border = "rounded",
			-- 			title = "{title} {live} {flags}",
			-- 			{ win = "input", height = 1, border = "bottom" },
			-- 			{ win = "list", border = "none" },
			-- 		},
			-- 		{
			-- 			win = "preview",
			-- 			title = "{preview}",
			-- 			border = "rounded",
			-- 			-- width = 0.5,
			-- 			width = 0.6,
			-- 		},
			-- 	},
			-- },

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
				Snacks.picker.files({
					layout = {
						preview = false,
					},
				})
			end,
			desc = "Find Files",
		},

		{
			"<leader>fk",
			function()
				-- source:
				-- https://github.com/folke/snacks.nvim/issues/1036#issuecomment-2734330151
				Snacks.picker.pick({
					title = "Directories",
					format = "text",
					layout = {
						preview = false,
					},
					finder = function(opts, ctx)
						local proc_opts = {
							cmd = "fd",
							args = { ".", "--type", "directory" },
						}
						return require("snacks.picker.source.proc").proc({ opts, proc_opts }, ctx)
					end,
					confirm = function(picker, item)
						picker:close()
						if item then
							vim.cmd("e " .. item.text)
						end
					end,
				})
			end,
			desc = "Find directories",
		},

		{
			"<leader>fc",
			function()
				Snacks.picker.commands()
			end,
			desc = "Find Commands",
		},

		{
			"<leader>fl",
			function()
				Snacks.picker.grep({
					title = "Tagged Files in CWD",
					layout = {
						preview = false,
					},
					exclude = {
						"Meetings",
						"Issues",
					},
					search = "^tags:\\s*\\[.*?",
					live = false, -- will show all files with tags which then can be fuzzy searched in the result list
					args = { "--max-count", "1" }, -- stop for each filter after 1 hit
					ft = "md",
				})
			end,
			desc = "Find tagged wiki fiLes in cwd",
		},

		{
			"<leader>fL",
			function()
				Snacks.picker.grep({
					title = "Tagged Files in CWD & Wiki",
					layout = {
						preview = false,
					},
					search = "^tags:\\s*\\[.*?",
					dirs = calculate_wiki_dirs(),
					live = false, -- will show all files with tags which then can be fuzzy searched in the result list
					args = { "--max-count", "1" }, -- stop for each filter after 1 hit
					ft = "md",
				})
			end,
			desc = "Find tagged wiki fiLes: cwd + global Wiki",
		},

		{
			"<leader>fm",
			function()
				Snacks.picker.files({
					title = "Meeting Notes",
					layout = {
						preview = false,
					},
					dirs = calculate_meeting_dirs(),
					exclude = {
						"Past",
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
			"<leader>fo",
			function()
				Snacks.picker.files({
					title = "Open Items",
					layout = {
						preview = false,
					},
					dirs = { "/home/xi3k/Notes/Open_Items" },
					exclude = {
						"Past",
					},
					ft = "md",
				})
			end,
			desc = "Find Space Meeting Notes",
		},

		{
			"<leader>fi",
			function()
				Snacks.picker.files({
					title = "Issues",
					layout = {
						preview = false,
					},
					dirs = calculate_issues_dirs(),
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
				Snacks.picker.buffers({
					layout = {
						preview = false,
					},
				})
			end,
			desc = "List Buffers",
		},

		{
			"<leader>fd",
			function()
				Snacks.picker.files({
					title = "Dotfiles",
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
						preview = false,
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
					title = "Grep Word in CWD",
					layout = {
						preview = false,
					},
				})
			end,
			desc = "Grep Word in CWD",
		},

		{
			"<leader>gwr",
			function()
				Snacks.picker.grep_word({
					title = "Grep word relative to current file",
					layout = {
						preview = false,
					},
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
					layout = {
						preview = "main",
						layout = {
							box = "vertical",
							backdrop = false,
							row = -1,
							width = 0,
							height = 0.4,
							border = "top",
							title = " {title} {live} {flags}",
							title_pos = "left",
							{ win = "input", height = 1, border = "bottom" },
							{
								box = "horizontal",
								{ win = "list", border = "none" },
								{ win = "preview", title = "{preview}", width = 0.6, border = "left" },
							},
						},
					},
				})
			end,
			desc = "Grep Lines",
		},

		{
			-- gO is a default nvim mapping since 0.11
			-- note: this is additionally set for markdown here: /home/xi3k/.config/nvim/after/ftplugin/markdown.lua
			"gO",
			function()
				Snacks.picker.lsp_symbols({
					layout = {
						preview = false,
						preset = "default",
					},
				})
			end,
			desc = "LSP Find Symbols",
		},

		{
			"<leader>gO",
			function()
				Snacks.picker.lsp_workspace_symbols({
					layout = {
						preview = false,
						preset = "default",
					},
				})
			end,
			desc = "LSP Find Workspace symbols",
		},
		{
			"gd",
			function()
				Snacks.picker.lsp_definitions({
					layout = {
						preview = false,
						preset = "default",
					},
				})
			end,
			desc = "Goto Definition",
		},
		{
			"gD",
			function()
				Snacks.picker.lsp_declarations({
					layout = {
						preview = false,
						preset = "default",
					},
				})
			end,
			desc = "Goto Declaration",
		},
		{
			-- grr is a default nvim mapping since 0.11
			"grr",
			function()
				Snacks.picker.lsp_references({
					layout = {
						preview = true,
						preset = "default",
					},
				})
			end,
			nowait = true,
			desc = "References",
		},
		{
			-- gri is a default nvim mapping since 0.11
			"gri",
			function()
				Snacks.picker.lsp_implementations({
					layout = {
						preview = true,
						preset = "default",
					},
				})
			end,
			desc = "Goto Implementation",
		},
		{
			"gy",
			function()
				Snacks.picker.lsp_type_definitions({
					layout = {
						preview = false,
						preset = "default",
					},
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
					title = "Grep relative to current file",
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
				Snacks.picker.keymaps({
					layout = {
						preview = false,
					},
				})
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

		{
			"<leader>rs",
			function()
				Snacks.picker.resume()
			end,
			desc = "Resume Search",
		},

		{
			"<leader>vl",
			function()
				Snacks.picker.git_log()
			end,
			desc = "View git Log",
		},

		{
			"<leader>vL",
			function()
				Snacks.picker.git_log_file()
			end,
			desc = "View git Log of current file",
		},

		{
			"<leader>vs",
			function()
				Snacks.picker.git_status()
			end,
			desc = "View git Status",
		},
	},
}
