-- Transform the relative filepath to a filepath relative to the CWD.
local function as_relative_to_current_buffer(path)
	-- Transform the relative filepath to a filepath relative to the CWD.
	-- Vimscript command: fnameescape(fnamemodify(expand('%:h').'/'.l:url.'.md', ':.'))
	-- ':.' Reduces the file name to be relative to the current directory.
	return vim.fn.fnameescape(vim.fn.fnamemodify(vim.fn.expand("%:h") .. "/" .. path, ":."))
end

local function getFileName(path)
	local filename = path:match("^.+/(.+)$")
	if filename == nil then
		filename = path
	end
	return filename
end

-- https://codereview.stackexchange.com/a/90231
local function getFileExtension(path)
	return path:match("^.+(%..+)$")
end

-----------------------------------------
-- Treesitter: Implement 'go to URL'
-- Keymap is configured in /home/xi3k/.config/nvim/after/ftplugin/markdown.vim
-----------------------------------------
-- Treesitter hierarchy:
--   inline_link [9, 12] - [9, 133]
--       link_text [9, 13] - [9, 36]
--       link_destination [9, 38] - [9, 132]
--
-- Logic:
-- If on inline_link || link_text || link_destination:
--   1. Get element link_destination.
--   2. Split link_destination at '#' into FILE and ANCHOR.
--   3. Open FILE.
--   4. Search and jump to ANCHOR.
function Jump_to_file_with_anchor()
	local row = vim.fn.line(".") - 1
	local col = vim.fn.col(".") - 1
	local selected_node = vim.treesitter.get_node({ 0, { row, col }, ignore_injections = false })

	local node_type = selected_node:type()
	if
		not (
			string.match(node_type, "inline_link")
			or string.match(node_type, "link_text")
			or string.match(node_type, "link_destination")
		)
	then
		print("Cursor is not on a link.")
		return
	end

	local dest_node = {}
	if string.match(node_type, "link_destination") then
		dest_node = selected_node
	end
	if string.match(node_type, "inline_link") then
		dest_node = selected_node:named_child(1)
	end
	if string.match(node_type, "link_text") then
		dest_node = selected_node:next_named_sibling()
	end
	local destination = vim.treesitter.get_node_text(dest_node, 0)

	-- add current position to the jump list
	vim.cmd("normal m`")

	-- Check if the destination contains a '#' at all.
	if destination:find("#") == nil then
		-- Does not contain a '#'.

		if require("plenary.path").new(destination):is_absolute() then
			vim.cmd("edit " .. destination)
			return
		end

		local target_relative = as_relative_to_current_buffer(destination)

		local fname = getFileName(target_relative)
		local file_extension = getFileExtension(fname)
		if file_extension == nil then
			target_relative = target_relative .. ".md"
		end

		vim.cmd("edit " .. target_relative)
		return
	end

	-- Split the destination at '#' into RELATIVE_FILEPATH and ANCHOR.
	local t = {}
	for str in string.gmatch(destination, "([^#]+)") do
		table.insert(t, str)
	end
	local tab_cnt = 0
	for _ in pairs(t) do
		tab_cnt = tab_cnt + 1
	end
	if tab_cnt ~= 1 and tab_cnt ~= 2 then
		print("Only links in the format '[FILEPATH]#ANCHOR' work.")
		return
	end

	-- RELATIVE_FILEPATH can be empty.
	if tab_cnt == 2 then
		local target_relative = as_relative_to_current_buffer(t[1])

		local fname = getFileName(target_relative)
		local file_extension = getFileExtension(fname)

		if file_extension == nil then
			target_relative = target_relative .. ".md"
		end

		vim.cmd("edit " .. target_relative)
	end

	-- Jump to the anchor.
	local anchor
	if tab_cnt == 2 then
		anchor = t[2]
	else
		anchor = t[1]
	end
	vim.cmd('/id="' .. anchor)
end

function Open_URL()
	local row = vim.fn.line(".") - 1
	local col = vim.fn.col(".") - 1
	local selected_node = vim.treesitter.get_node({ 0, { row, col }, ignore_injections = false })

	local node_type = selected_node:type()
	local url = ""
	if
		string.match(node_type, "inline_link")
		or string.match(node_type, "link_text")
		or string.match(node_type, "link_destination")
	then
		local dest_node = {}
		if string.match(node_type, "link_destination") then
			dest_node = selected_node
		end
		if string.match(node_type, "inline_link") then
			dest_node = selected_node:named_child(1)
		end
		if string.match(node_type, "link_text") then
			dest_node = selected_node:next_named_sibling()
		end
		url = vim.treesitter.get_node_text(dest_node, 0)
	else
		url = vim.fn.expand("<cWORD>")
	end

	-- vim.keymap.set("n", "gx", ":call system('www-browser <C-r><C-a>')<CR>", { silent = true })
	vim.cmd("call system('www-browser \"" .. url .. "\"')")
end

return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		main = "render-markdown",
		opts = {
			heading = {
				-- disable sign column related rendering
				sign = false,
				-- disable icons for headers
				icons = {},
				-- disable backgrounds
				backgrounds = {},
				-- -- do not cover the whole window with with the header background
				-- width = "block",
				-- -- left_pad = 2,
				-- right_pad = 1,
			},
			code = {
				-- turn on off any sign column related rendering
				sign = false,
				-- Width of the code block background:
				--  block: width of the code block
				width = "block",
				right_pad = 2,
				border = "thick",
				-- change inline code highlighting
				-- highlight_inline = "RenderMarkdownCodeInline",
				highlight_inline = "CustomMarkdownInlineCodeBlock",
			},
			checkbox = {
				position = "overlay",
			},
			dash = {
				enabled = false,
				-- width = 15,
			},
			link = {
				wiki = { icon = "↪ " },
			},
		},
		name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
		-- dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }, -- if you use standalone mini plugins
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
	},

	{
		-- 2025-02-14: Disabling this as I am using this plugin only for jumping to next
		-- header and next link.
		"jakewvincent/mkdnflow.nvim",
		ft = { "markdown" },
		enabled = false,
		config = function()
			require("mkdnflow").setup({
				modules = {
					bib = false,
					buffers = false,
					-- 2024-07-26, disable conceal because of markdown.nvim
					conceal = false,
					cursor = true,
					folds = false,
					links = true, -- used for jump to next link
					lists = false,
					maps = true, -- keymaps
					paths = false,
					tables = false,
				},
				filetypes = { md = true, rmd = true, markdown = true },
				create_dirs = true,
				perspective = {
					-- priority = 'first',
					priority = "current",
					fallback = "current",
					root_tell = false,
					nvim_wd_heel = false,
				},
				wrap = false,
				silent = false,
				links = {
					style = "wiki", -- 2025-02-14 changed due to my new notes setup
					name_is_source = false,
					-- concealing is done by treesitter
					conceal = false,
					implicit_extension = "md",
					transform_implicit = false,
					transform_explicit = function(text)
						text = text:gsub(" ", "-")
						text = text:lower()
						text = os.date("%Y-%m-%d_") .. text
						return text
					end,
				},
				to_do = {
					symbols = { " ", "-", "X" },
					update_parents = true,
					not_started = " ",
					in_progress = "-",
					complete = "X",
				},
				tables = {
					trim_whitespace = true,
					format_on_move = true,
					auto_extend_rows = false,
					auto_extend_cols = false,
				},
				mappings = {
					MkdnEnter = false,
					MkdnTab = false,
					MkdnSTab = false,
					MkdnNextLink = { { "n", "v" }, "]r" },
					MkdnPrevLink = { { "n", "v" }, "[r" },
					MkdnNextHeading = { { "n", "v" }, "]]" },
					MkdnPrevHeading = { { "n", "v" }, "[[" },
					MkdnGoBack = false,
					MkdnGoForward = false,
					MkdnFollowLink = false,
					MkdnDestroyLink = false,
					MkdnTagSpan = false,
					MkdnMoveSource = false,
					MkdnYankAnchorLink = false,
					MkdnYankFileAnchorLink = false,
					MkdnIncreaseHeading = false,
					MkdnDecreaseHeading = false,
					MkdnToggleToDo = false,
					MkdnNewListItem = false,
					MkdnNewListItemBelowInsert = false,
					MkdnNewListItemAboveInsert = false,
					MkdnExtendList = false,
					MkdnUpdateNumbering = false,
					MkdnTableNextCell = false,
					MkdnTablePrevCell = false,
					MkdnTableNextRow = false,
					MkdnTablePrevRow = false,
					MkdnTableNewRowBelow = false,
					MkdnTableNewRowAbove = false,
					MkdnTableNewColAfter = false,
					MkdnTableNewColBefore = false,
					MkdnFoldSection = false,
					MkdnUnfoldSection = false,
					MkdnCreateLinkFromClipboard = false,
				},
			})

			vim.cmd([[
                " Command to export a markdown file as docx to DebianShare/Export_docx
                " The file DebianShare/Export_docx/_Pandoc_reference_for_export.docx provides the styles.
                "
                " The current working directory is temporarily switched to the file's directory such that 
                " images are also exported.
                "
                " +task_lists interprets - [ ] as checkbox
                " +pipe_tables interpretes pipe tables
                " 
                " The redraw! is required to update Vim's screen after the command has been executed.
                function! MarkdownMdToDocx()
                  " Change the working directory temporarily.
                  lcd %:h
                  
                  let src_filename = fnameescape(expand('%:p'))
                  let dst_filename = input('Enter filename: ' )
                  if strlen(dst_filename) == 0
                    " %:t:r - select the 'tail' of the path (filename) but without the file extension.
                    let today = strftime('%y-%m-%d')
                    let dst_filename = '~/VmHostShare/Export/'.fnameescape(expand('%:t:r')).'_'.today.'.docx'
                  else
                    let dst_filename = '~/VmHostShare/Export/'.dst_filename
                  end
                  silent execute
                    "\ "!pandoc -f markdown+task_lists+pipe_tables
                    \ "!pandoc -f gfm
                    \ --reference-doc ~/VmHostShare/Pandoc_Markdown_To_Docx_Template.docx
                    \ -s ".src_filename." -o ".dst_filename | redraw!
                  echo dst_filename.' exported.'

                  " Change the working directory back.
                  lcd -
                endfunction

                command ToDocx call MarkdownMdToDocx()
            ]])
		end,
	},

	{
		"HakonHarnes/img-clip.nvim",
		event = "VeryLazy",
		opts = {
			filetypes = {
				markdown = {
					dir_path = ".img", ---@type string | fun(): string
					extension = "png", ---@type string | fun(): string
					file_name = "%Y-%m-%d-%H-%M-%S", ---@type string | fun(): string
					use_absolute_path = false, ---@type boolean | fun(): boolean
					relative_to_current_file = true, ---@type boolean | fun(): boolean
					url_encode_path = true, ---@type boolean | fun(): boolean
					template = "![$CURSOR]($FILE_PATH)", ---@type string | fun(context: table): string
					download_images = false, ---@type boolean | fun(): boolean
				},
			},
		},
		keys = {
			-- suggested keymap
			{ "<leader>mp", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
		},
	},

	{
		"iamcco/markdown-preview.nvim",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		event = "VeryLazy",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
			-- Research: Why does this not work?
			-- vim.g.mkdp_page_title = "${name}"

			vim.g.mkdp_preview_options = {
				disable_sync_scroll = true,
			}
		end,
		keys = {
			{ "<leader>ms", ":MarkdownPreview<CR>", { silent = true } },
			{ "<leader>mc", ":MarkdownPreviewStop<CR>", { silent = true } },
		},
	},

	{
		"folke/todo-comments.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
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
				CONT = { icon = "➤ ", color = "hint" },
				WAIT = { icon = " ", color = "warning" },
				HACK = { icon = " ", color = "warning" },
				WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
				PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
				NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
				TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
			},
		},
		keys = {
			{
				"<leader>lt",
				function()
					---@diagnostic disable-next-line: undefined-field
					Snacks.picker.pick({
                        source = "todo_comments",
						keywords = { "CONT", "NEXT", "TODO", "WAIT" },
						ft = "md",
						sort = {
							fields = {
								"line", -- contains the matching keyword. this will sort NEXT > TODO > WAIT.
								"score:desc",
								-- "idx",
								-- "#text",
							},
						},
						matcher = {
                            sort_empty = true,
							frecency = false, -- frecency bonus
							history_bonus = false, -- give more weight to chronological order
							cwd_bonus = false,
						},
						layout = {
							preview = "main",
							preset = "ivy",
							layout = {
								position = "bottom",
								-- all values are defaults except for the title
								-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#default
								box = "horizontal",
								width = 1,
								min_width = 120,
								height = 0.4,
								{
									box = "vertical",
									border = "rounded",
									title = "Todos {live} {flags}",
									{ win = "input", height = 1, border = "bottom" },
									{ win = "list", border = "none" },
								},
								{ win = "preview", title = "{preview}", border = "rounded", width = 0.5 },
							},
						},
					})
				end,
				desc = "List Todos",
			},
		},
	},
}
