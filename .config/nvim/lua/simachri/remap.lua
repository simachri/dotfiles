vim.g.mapleader = " "

-- Move lines up or down
-- Use 'x' mode instead of 'v' to not interfere when inserting a link (URL) through
-- snippets and the link name starts with a capital letter j or k.
vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("x", "K", ":m '<-2<CR>gv=gv")

-- Note: For Markdown files, there is a remap in /home/xi3k/.config/nvim/after/ftplugin/markdown.vim
vim.keymap.set(
	"n",
	"gx",
	":call system('www-browser <C-r><C-a>')<CR>",
	{ silent = true, desc = "Open with Web Browser" }
)

-- Do not override the buffer when pasting.
-- https://stackoverflow.com/a/3837845
vim.keymap.set("x", "<Leader>pp", '"_dP')

-- Prevent <leader><CR> to convert the word under cursor into a link (for some reason).
vim.keymap.set("n", "<Leader><CR>", "<Esc>")

-- -- Keymap to sync syntax highlighting again if it is broken.
-- -- See :h redrawtime
-- vim.keymap.set("n", "<Leader>e", "mx:e<CR>:syntax sync fromstart<CR>`x", { silent = true })

-- Jump to alternate file.
vim.keymap.set("n", "<C-e>", ":b#<CR>")

-- Undo breakpoints
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", "!", "!<c-g>u")
vim.keymap.set("i", "?", "?<c-g>u")

-- Jumplist mutations when doing relative movement of more than five lines.
vim.keymap.set("n", "k", '(v:count > 5 ? "m\'" . v:count : "") . \'k\'', { expr = true })
vim.keymap.set("n", "j", '(v:count > 5 ? "m\'" . v:count : "") . \'j\'', { expr = true })

-- Keep the screen centered when using n & N for cycling through search results.
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

-- Close all buffers.
-- The :silent! is used to omit the error message when
-- terminals are running: E89
vim.keymap.set("n", "<C-w>c", ":silent! %bd<CR>", { silent = true })

-- Let Y yank to end of line instead of entire line.
vim.keymap.set("n", "Y", "y$")

-- Insertion of blank lines
-- maps to [-space and ]-space by default since nvim 0.11
-- vim.keymap.set("n", "<C-j>", ":set paste<CR>m`o<Esc>``:set nopaste<CR>", { silent = true })
-- vim.keymap.set("n", "<C-k>", ":set paste<CR>m`O<Esc>``:set nopaste<CR>", { silent = true })
-- Prevent in insert-like modes to not mess with Luasnip mappings.
-- vim.keymap.set("x", "<C-j>", "my<Esc>`>o<Esc>gv`y", { silent = true })
-- vim.keymap.set("x", "<C-k>", "my<Esc>`<O<Esc>gv`y", { silent = true })

-- Replace word word under cursor
vim.keymap.set("n", "<Leader>rr", ":%s/\\<<C-r><C-w>\\>//gI<Left><Left><Left>", { silent = true })
-- Replace selection
vim.keymap.set("v", "<Leader>rr", '"sy:%s/<C-r>s//gI<Left><Left><Left>', { silent = true })

-- Remap the join lines J command, such that the cursor remains at the position
-- https://stackoverflow.com/questions/9505198/join-two-lines-in-vim-without-moving-cursor
vim.keymap.set("n", "J", ":let p=getpos('.')<bar>join<bar>call setpos('.', p)<cr>", { silent = true })

-- Yank the full filepath into the clipboard.
vim.keymap.set("n", "<leader>yp", [[:lua YankFullFilepath()<CR>]], { noremap = true, silent = true })

function YankFullFilepath()
	local filepath = vim.fn.expand("%:p")
	vim.fn.setreg("+", filepath)
	print("Filepath yanked")
end

-- Yank Reference: filename without extension into register + (system clipboard)
vim.keymap.set("n", "<leader>yr", function()
	local filename = vim.fn.expand("%:t:r")
	if filename == "" then
		print("No filename to yank")
		return
	end

	local final_yank = filename
	local filetype = vim.bo.filetype

	if filetype == "markdown" then
		local line = vim.api.nvim_get_current_line()
		local header_match = line:match("^(##+)%s*(.*)")

		if header_match then
			local header = line:gsub("^#+%s*", "") -- Remove leading #'s and spaces
			final_yank = filename .. "#" .. header
		end
	end

	vim.fn.setreg("+", final_yank) -- System clipboard
	vim.fn.setreg('"', final_yank) -- Default register
	print("Yanked: " .. final_yank)
end, { noremap = true, silent = true, desc = "Yank filename; respect Markdown header" })

-- Paste Reference: create a markdown wiki link from register x (system clipboard)
vim.keymap.set("n", "<leader>pr", [[:lua PasteWithBrackets()<CR>]], { noremap = true, silent = true })

function PasteWithBrackets()
	local content = vim.fn.getreg("+")
	local wrapped_content = "[[" .. content .. "]]"
	vim.api.nvim_put({ wrapped_content }, "c", true, true)
end

-- Location list: Next and previous
vim.keymap.set("n", "<Leader>ln", ":lnext<CR>")
vim.keymap.set("n", "<Leader>lp", ":lprev<CR>")

-- Quickfix list: Next and previous
vim.keymap.set("n", "<Leader>qn", ":lnext<CR>")
vim.keymap.set("n", "<Leader>qp", ":lprev<CR>")

vim.keymap.set("n", "Q", "<nop>")

-- Toggle highlighting of search hits.
vim.keymap.set("n", "<Leader>th", ":set hlsearch!<CR>", { silent = true })

-- function OpenScratchBuffer()
-- 	-- Check if a scratch buffer already exists.
-- 	if vim.fn.bufnr("scratch") ~= -1 then
-- 		vim.cmd("e scratch")
-- 		return
-- 	else
-- 		vim.cmd([[
--         noswapfile hide enew
--         file scratch
--         setlocal buftype=nofile
--         setlocal bufhidden=hide
--         setlocal tw=0
--         setlocal ft=markdown
--         ]])
-- 	end
-- end
-- vim.keymap.set("n", "<Leader>i", ":lua OpenScratchBuffer()<CR>", { noremap = true, silent = true })

vim.cmd([[
    function! ToggleCb(option)
      let currLineText = getline(".")
      " If an option is given, evaluate it directly.
      if a:option == "done"
        call setline(".", substitute(currLineText, "- [.*\\]", "- [x]", ""))
        return
      elseif a:option == "open"
        call setline(".", substitute(currLineText, "- [.*\\]", "- [ ]", ""))
        return
      elseif a:option == "up"
        call setline(".", substitute(currLineText, "- [.*\\]", "- [^]", ""))
        return
      endif

      " If checkbox is empty: Check it.
      let replacedText = substitute(currLineText, "- [ \\]", "- [x]", "")
      if currLineText != replacedText
        " Replace text.
        call setline(".", replacedText)
        return
      endif

      " If checkbox is checked: Set to invalid.
      let replacedText = substitute(currLineText, "- [x\\]", "- [-]", "")
      if currLineText != replacedText
        " Replace text.
        call setline(".", replacedText)
        return
      endif

      " If checkbox is invalid: Set to follow-up.
      let replacedText = substitute(currLineText, "- [-\\]", "- [^]", "")
      if currLineText != replacedText
        " Replace text.
        call setline(".", replacedText)
        return
      endif

      " If checkbox is set to follow-up: Clear it.
      let replacedText = substitute(currLineText, "- [^\\]", "- [ ]", "")
      if currLineText != replacedText
        " Replace text.
        call setline(".", replacedText)
        return
      endif

      " No checkbox available yet. Add one.
      normal I- [ ] 
    endfunction
    command ToggleCheckBox call ToggleCb('')
    command SetCheckBoxDone call ToggleCb('done')
    command SetCheckBoxOpen call ToggleCb('open')
    command SetCheckBoxUp call ToggleCb('up')
    " nnoremap <silent> <Leader>cc :ToggleCheckBox<CR>
    " nnoremap <silent> <Leader>cc :SetCheckBoxDone<CR>
    nnoremap <silent> <Leader>co :SetCheckBoxOpen<CR>
    " nnoremap <silent> <Leader>tcu :SetCheckBoxUp<CR>
]])

function MarkToDoCommentAsDone()
	local replacement_candidates = { "PENDING:", "TODO:", "NEXT:", "CONT:", "%- %[ %]" }
	local replacement = "- [x]"
	local line_contents = vim.api.nvim_get_current_line()
	local line_contains_candidate = false

	for _, str in ipairs(replacement_candidates) do
		if line_contents:find(str) then
			line_contains_candidate = true
			break
		end
	end

	if not line_contains_candidate then
		print("Nothing to be marked as done.")
		return
	end

	for _, str in ipairs(replacement_candidates) do
		line_contents = line_contents:gsub(str, replacement)
	end
	vim.api.nvim_set_current_line(line_contents)

	print("Marked as done.")
end
vim.keymap.set(
	"n",
	"<leader>cd",
	":lua MarkToDoCommentAsDone()<CR>",
	{ desc = "Mark ToDo Comment as Done", noremap = true, silent = true }
)

function Rename_md_file_from_h1()
	local line = vim.api.nvim_get_current_line()

	local header = line:match("^#%s+(.+)")
	if not header then
		print("No H1 header found under cursor!")
		return
	end

	local filename = header:gsub("%s+", "_"):gsub("[^a-zA-Z0-9%_äöüÖÜÄ]", "")

	local old_path = vim.fn.expand("%:p")
	local dir = vim.fn.expand("%:p:h")
	local ext = ".md"
	local new_path = dir .. "/" .. filename .. ext

	if vim.fn.filereadable(new_path) == 1 then
		print("File already exists: " .. new_path)
		return
	end

	vim.cmd("keepalt write")

	os.rename(old_path, new_path)

	vim.api.nvim_command("keepalt edit " .. new_path)

	-- notify LSP
	Snacks.rename.on_rename_file(old_path, new_path)

	print("Renamed file to: " .. filename .. ext)
end

vim.keymap.set(
	"n",
	"<leader>sfh",
	":lua Rename_md_file_from_h1()<CR>",
	{ noremap = true, silent = true, desc = "Set FileName from header" }
)

vim.keymap.set(
	"n",
	"<leader>ga",
	[[:lua CreateWikiLinkToRegisterX()<CR>]],
	{ noremap = true, silent = true, desc = "Generate Wiki Link Anchor" }
)

function CreateWikiLinkToRegisterX()
	local line = vim.api.nvim_get_current_line()
	local header = line:match("^#%s+(.+)")
	if header then
		local link = header
			:lower()
			:gsub("[^%w%- äöüÄÖÜ]", "") -- Remove any punctuations except hyphens, spaces, and German Umlauts
			:gsub("%s", "-") -- Replace spaces with dashes
			:gsub("%-+", "-") -- Remove multiple consecutive dashes
			:gsub("^%-", "") -- Remove leading dash
			:gsub("%-$", "") -- Remove trailing dash

		local wikilink = string.format("%s", link)
		vim.fn.setreg("x", wikilink)
		print("Created wiki link and yanked to register 'x'.")
	else
		print("No H1 header found on this line.")
	end
end

function Open_or_create_weekly_note()
	local year = os.date("%Y")
	local week_number = os.date("%W") + 1 -- is off by one in 2025
	local formatted_week_number = string.format("%02d", week_number)

	-- get the month from the current week's monday
	local current_date = os.date("*t")
	local days_since_monday = (current_date.wday - 2) % 7
	local monday_timestamp = os.time(current_date) - (days_since_monday * 86400)
	local month_short = os.date("%b", monday_timestamp)

	local file_path =
		string.format("%s/Notes/Weekly/%s/Week-%s-%s.md", os.getenv("HOME"), year, formatted_week_number, month_short)

	local file = io.open(file_path, "r")
	if file then
		file:close()
		vim.cmd("edit " .. file_path)
	else
		vim.cmd("edit " .. file_path)

		-- Wait for buffer to load, then insert a specific LuaSnip snippet
		vim.schedule(function()
			local snips = require("luasnip").get_snippets()["markdown"]
			for _, snip in ipairs(snips) do
				if snip["name"] == "Weekly Note" then
					require("luasnip").snip_expand(snip)
					-- Wait for snippet expansion and then exit insert mode and save
					vim.schedule(function()
						vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
						vim.cmd("write")
					end)
					return
				end
			end
		end)
	end
end

vim.keymap.set(
	"n",
	"<leader>fw",
	":lua Open_or_create_weekly_note()<CR>",
	{ noremap = true, silent = true, desc = "Open Weekly note" }
)

function Create_project_meeting_note()
	local projects_dir = os.getenv("HOME") .. "/Notes/Projects"
	local current_dir = vim.fn.getcwd()
	local project = nil
	local project_path = nil

	-- check if CWD is already in a project directory
	if current_dir:sub(1, #projects_dir) == projects_dir then
		local relative_path = current_dir:sub(#projects_dir + 2)
		if relative_path and relative_path ~= "" then
			project = relative_path:match("^([^/]+)")
			if project then
				project_path = projects_dir .. "/" .. project
			end
		end
	end

	-- if not in a project directory, show the project selection
	if not project then
		local handle = vim.loop.fs_scandir(projects_dir)
		if not handle then
			vim.notify("Could not access projects directory", vim.log.levels.ERROR)
			return
		end

		local projects = {}
		while true do
			local name, type = vim.loop.fs_scandir_next(handle)
			if not name then
				break
			end
			if type == "directory" then
				table.insert(projects, name)
			end
		end

		if #projects == 0 then
			vim.notify("No projects found", vim.log.levels.ERROR)
			return
		end

		table.sort(projects)

		vim.ui.select(projects, {
			prompt = "Select project:",
			format_item = function(item)
				return item
			end,
		}, function(selected_project)
			if not selected_project then
				return
			end
			project = selected_project
			project_path = projects_dir .. "/" .. project
			create_meeting_note_in_project(project_path)
		end)
	else
		-- directly create meeting note in current project
		create_meeting_note_in_project(project_path)
	end
end

function create_meeting_note_in_project(project_path)
	local meetings_dir = project_path .. "/Meetings"

	local stat = vim.loop.fs_stat(meetings_dir)
	if not stat then
		local success = vim.fn.mkdir(meetings_dir, "p")
		if success == 0 then
			vim.notify("Failed to create Meetings directory", vim.log.levels.ERROR)
			return
		end
	elseif stat.type ~= "directory" then
		vim.notify("Meetings path exists but is not a directory", vim.log.levels.ERROR)
		return
	end

	vim.ui.input({
		prompt = "Meeting filename (without date): ",
	}, function(filename)
		if not filename or filename == "" then
			return
		end

		-- clean filename - remove any existing date suffix and .md extension
		filename = filename:gsub("_?%d%d%d%d%-%d%d%-%d%d%.md$", "")
		filename = filename:gsub("%.md$", "")

		local date = os.date("%Y-%m-%d")
		local full_filename = filename .. "_" .. date .. ".md"
		local file_path = meetings_dir .. "/" .. full_filename

		local file_exists = vim.loop.fs_stat(file_path)
		if file_exists then
			vim.notify("File already exists: " .. full_filename, vim.log.levels.ERROR)
			return
		end

		vim.cmd("edit " .. file_path)

		vim.schedule(function()
			local snips = require("luasnip").get_snippets()["markdown"]
			for _, snip in ipairs(snips) do
				if snip["name"] == "Meeting Notes" then
					require("luasnip").snip_expand(snip)
					-- wait for snippet expansion and then exit insert mode
					vim.defer_fn(function()
						require("luasnip").unlink_current()
						vim.cmd.stopinsert()
					end, 50)
					return
				end
			end
			vim.notify("Meeting Notes snippet not found", vim.log.levels.WARN)
		end)
	end)
end

vim.keymap.set(
	"n",
	"<leader>cm",
	":lua Create_project_meeting_note()<CR>",
	{ noremap = true, silent = true, desc = "Create project meeting note" }
)

vim.keymap.set(
	"t",
	"<Esc>",
	"<C-\\><C-n>",
	{ noremap = true, silent = true, desc = "Terminal: Switch from TERMINAL to NORMAL mode" }
)
vim.keymap.set(
	"t",
	"<C-c>",
	"<C-\\><C-n>",
	{ noremap = true, silent = true, desc = "Terminal: Switch from TERMINAL to NORMAL mode" }
)

vim.keymap.set("n", "ci*", "/*<CR>cT*", { desc = "Change inside *" })
vim.keymap.set("n", "ci_", "/_<CR>cT_", { desc = "Change inside _" })
vim.keymap.set("n", "ca*", "/*<CR>vF*c", { desc = "Change around *" })
vim.keymap.set("n", "ca_", "/_<CR>vF_c", { desc = "Change around _" })
