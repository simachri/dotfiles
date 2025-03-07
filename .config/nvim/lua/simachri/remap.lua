vim.g.mapleader = " "

-- Move lines up or down
-- Use 'x' mode instead of 'v' to not interfere when inserting a link (URL) through
-- snippets and the link name starts with a capital letter j or k.
vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("x", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "gx", ":call system('www-browser <C-r><C-a>')<CR>", { silent = true })

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
vim.keymap.set("n", "<C-j>", ":set paste<CR>m`o<Esc>``:set nopaste<CR>", { silent = true })
vim.keymap.set("n", "<C-k>", ":set paste<CR>m`O<Esc>``:set nopaste<CR>", { silent = true })
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
vim.api.nvim_set_keymap("n", "<leader>yp", [[:lua YankFullFilepath()<CR>]], { noremap = true, silent = true })

function YankFilename()
	local filepath = vim.fn.expand("%:p")
	vim.fn.setreg("+", filepath)
	print("Filepath yanked")
end

-- Yank Reference: filename without extension into register + (system clipboard)
vim.api.nvim_set_keymap("n", "<leader>yr", [[:lua YankFilename()<CR>]], { noremap = true, silent = true })

function YankFilename()
	local filename = vim.fn.expand("%:t:r")
	vim.fn.setreg("+", filename)
	print("Filename yanked")
end

-- Paste Reference: create a markdown wiki link from register x (system clipboard)
vim.api.nvim_set_keymap('n', '<leader>pr', [[:lua PasteWithBrackets()<CR>]], { noremap = true, silent = true })

function PasteWithBrackets()
  local content = vim.fn.getreg('+')
  local wrapped_content = '[[' .. content .. ']]'
  vim.api.nvim_put({wrapped_content}, 'c', true, true)
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
-- vim.api.nvim_set_keymap("n", "<Leader>i", ":lua OpenScratchBuffer()<CR>", { noremap = true, silent = true })

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
vim.api.nvim_set_keymap(
	"n",
	"<leader>cc",
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

vim.api.nvim_set_keymap(
	"n",
	"<leader>sfh",
	":lua Rename_md_file_from_h1()<CR>",
	{ noremap = true, silent = true, desc = "Set FileName from header" }
)

vim.api.nvim_set_keymap(
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
	local month_short = os.date("%b")
	local file_path = string.format(
		"%s/Notes/Work/Weekly/%s/Week-%s-%s.md",
		os.getenv("HOME"),
		year,
		formatted_week_number,
		month_short
	)

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
					vim.cmd("write")
					return true
				end
			end
		end)
	end
end

vim.api.nvim_set_keymap(
	"n",
	"<leader>jj",
	":lua Open_or_create_weekly_note()<CR>",
	{ noremap = true, silent = true, desc = "Weekly Note" }
)
