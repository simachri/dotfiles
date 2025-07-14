local function calculate_search_dirs(dir_type)
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
		"Nexus",
		"Threedy",
		"DIEHL",
		"Sartorius",
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

function Find_tagged_files(opts)
	opts = opts or {}

	local default_config = {
		title = "Tagged Files",
		search = "^tags:\\s*\\[.*?",
		live = false,
		args = { "--max-count", "1" },
		ft = "md",
	}

	local config = vim.tbl_deep_extend("force", default_config, opts)

	Snacks.picker.grep(config)
end

local function calculate_meeting_dirs()
	return calculate_search_dirs("Meetings")
end

local function calculate_issues_dirs()
	return calculate_search_dirs("Issues")
end

function Calculate_wiki_dirs()
	local cwd = vim.fn.getcwd()
	local wiki_base = "/home/xi3k/Notes"

	local paths = { wiki_base }

	if cwd ~= wiki_base then
		table.insert(paths, cwd)
	end

	return paths
end

local function create_issue_finder(include_hidden)
	return function(opts)
		local issue_dirs = calculate_issues_dirs()

		-- Filter out non-existent directories
		local existing_dirs = {}
		for _, dir in ipairs(issue_dirs) do
			if vim.fn.isdirectory(dir) == 1 then
				table.insert(existing_dirs, dir)
			end
		end

		if #existing_dirs == 0 then
			return {}
		end

		local fd_cmd = { "fd", ".", "--type", "file", "--extension", "md", "--print0" }
		if include_hidden then
			table.insert(fd_cmd, "--hidden")
		end
		for _, dir in ipairs(existing_dirs) do
			table.insert(fd_cmd, dir)
		end

		local files_str = vim.fn.system(fd_cmd)
		files_str = files_str:gsub("[\001-\031]", "\0") -- Replace control chars with null bytes
		local files = vim.split(files_str, "\0", { plain = true, trimempty = true })

		local items = {}
		for _, file_path in ipairs(files) do
			local content = vim.fn.readfile(file_path)
			local priority = opts.data.default
			local tags_str = ""
			local prio_match = nil

			local in_frontmatter = false
			for i, line in ipairs(content) do
				if i == 1 and line == "---" then
					in_frontmatter = true
				elseif in_frontmatter and line == "---" then
					in_frontmatter = false
					break
				elseif in_frontmatter then
					local prio_found = string.match(line, "priority: (%w+)")
					if prio_found then
						prio_match = prio_found
						priority = opts.data[prio_found] or opts.data.default
					end

					local tags_match = string.match(line, "tags:%s*%[(.*)%]")
					if tags_match then
						tags_str = tags_match
					end
				end
			end

			local filename = vim.fn.fnamemodify(file_path, ":t:r") -- get filename without extension
			
			-- Extract project name from file path
			-- Path structure: /home/xi3k/Notes/Projects/{PROJECT}/Issues/...
			local project_name = ""
			local path_parts = vim.split(file_path, "/", { plain = true })
			for i, part in ipairs(path_parts) do
				if part == "Projects" and i + 1 <= #path_parts then
					project_name = path_parts[i + 1]
					break
				end
			end

			-- Clean up tags: remove "issue" tag and split/rejoin
			local cleaned_tags = ""
			if tags_str ~= "" then
				local tag_list = {}
				for tag in tags_str:gmatch("[^,]+") do
					tag = tag:match("^%s*(.-)%s*$") -- trim whitespace
					if tag ~= "issue" then
						table.insert(tag_list, tag)
					end
				end
				cleaned_tags = table.concat(tag_list, ", ")
			end

			local display_text
			if cleaned_tags ~= "" then
				display_text = string.format("[%s] %s: %s | %s", prio_match or "medium", project_name, filename, cleaned_tags)
			else
				display_text = string.format("[%s] %s: %s", prio_match or "medium", project_name, filename)
			end

			table.insert(items, {
				text = display_text,
				file = file_path,
				value = file_path,
				priority = priority,
				tags = tags_str,
				project = project_name,
				-- Add searchable content that includes tags and project for filtering
				search_text = display_text .. " " .. tags_str .. " " .. project_name,
			})
		end
		return items
	end
end

local function create_issue_picker_config(title, include_hidden)
	return {
		title = title,
		format = "text",
		layout = {
			preview = false,
		},
		data = {
			high = 3,
			medium = 2,
			low = 1,
		},
		sort = {
			fields = { "priority:desc", "score:desc", "text" },
		},
		-- Disable live search since we're using a custom finder
		live = false,
		-- Configure matcher to search in our custom search_text field
		matcher = {
			fields = { "text", "tags", "search_text" },
			sort_empty = true,
		},
		finder = create_issue_finder(include_hidden),
		confirm = function(picker, item)
			picker:close()
			if item then
				vim.cmd("e " .. item.value)
			end
		end,
	}
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
			scratch = {
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
			"<leader>fn",
			function()
				Snacks.picker.notifications({
					layout = {
						preview = false,
					},

					win = {
						list = {
							wo = {
								wrap = true,
							},
						},
					},
				})
			end,
			desc = "Notification History",
		},

		{
			"<leader>.",
			function()
				Snacks.scratch()
			end,
			desc = "Toggle Scratch Buffer",
		},

		-- {
		-- 	"<leader>ls",
		-- 	function()
		-- 		Snacks.scratch.select()
		-- 	end,
		-- 	desc = "List Scratch Buffers",
		-- },

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


        -- is mapped in the respective .nvim.lua
		-- {
		-- 	"<leader>fl",
		-- 	function()
		-- 		Snacks.picker.grep({
		-- 			title = "Tagged Files in CWD",
		-- 			-- layout = {
		-- 			-- 	preview = false,
		-- 			-- },
		-- 			exclude = {
		-- 				"Meetings",
		-- 				"Issues",
		-- 			},
		-- 			search = "^tags:\\s*\\[.*?",
		-- 			live = false, -- will show all files with tags which then can be fuzzy searched in the result list
		-- 			args = { "--max-count", "1" }, -- stop for each filter after 1 hit
		-- 			ft = "md",
		-- 		})
		-- 	end,
		-- 	desc = "Find tagged wiki fiLes in cwd",
		-- },
		--
		-- {
		-- 	"<leader>fL",
		-- 	function()
		-- 		Snacks.picker.grep({
		-- 			title = "Tagged Files in CWD & Wiki",
		-- 			-- layout = {
		-- 			-- 	preview = false,
		-- 			-- },
		-- 			search = "^tags:\\s*\\[.*?",
		-- 			dirs = Calculate_wiki_dirs(),
		-- 			live = false, -- will show all files with tags which then can be fuzzy searched in the result list
		-- 			args = { "--max-count", "1" }, -- stop for each filter after 1 hit
		-- 			ft = "md",
		-- 		})
		-- 	end,
		-- 	desc = "Find tagged wiki fiLes: cwd + global Wiki",
		-- },

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
					matcher = {
						sort_empty = true,
					},
					ft = "md",
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
			"<leader>fM",
			function()
				Snacks.picker.files({
					title = "Meeting Notes (including past)",
					layout = {
						preview = false,
					},
					dirs = calculate_meeting_dirs(),
					matcher = {
						sort_empty = true,
					},
					ft = "md",
					sort = {
						-- default sort is by score, text length and index
						fields = { "score:desc", "text:desc", "#text", "idx" },
					},
				})
			end,
			desc = "Find All Meeting Notes",
		},

		{
			"<leader>fo",
			function()
				Snacks.picker.files({
					title = "Follow-ups",
					layout = {
						preview = false,
					},
					matcher = {
						sort_empty = true,
					},
					dirs = { "/home/xi3k/Notes/Open_Items" },
					exclude = {
						"Past",
					},
					ft = "md",
				})
			end,
			desc = "Find Follow-ups",
		},

		{
			"<leader>fi",
			function()
				Snacks.picker.pick(create_issue_picker_config("Issues", false))
			end,
			desc = "Find Space Issues",
		},

		{
			"<leader>fI",
			function()
				Snacks.picker.pick(create_issue_picker_config("Issues - include closed (hidden)", true))
			end,
			desc = "Find Space Issues - include closed (hidden)",
		},

		{
			"<leader>fb",
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
			"<leader>gw",
			function()
				Snacks.picker.grep_word({
					title = "Grep word or visual selection in CWD",
					layout = {
						preview = false,
					},
				})
			end,
			desc = "Grep Word in CWD",
			mode = { "n", "x" },
		},

		{
			"<leader>gW",
			function()
				Snacks.picker.grep_word({
					title = "Grep word or visual selection relative to current file",
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
			mode = { "n", "x" },
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
			-- Grep Help tags
			"<leader>gh",
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
