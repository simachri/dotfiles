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

	if not selected_node then
		vim.notify("No Treesitter node found!", vim.log.levels.WARN)
		return
	end

	local node_type = selected_node:type()
	local url = ""

	-- vim.notify("node_type: " .. node_type, vim.log.levels.debug)

	if
		node_type == "inline_link"
		or node_type == "link_text"
		or node_type == "link_destination"
		or node_type == "shortcut_link"
	then
		local dest_node = nil

		if node_type == "link_destination" or node_type == "shortcut_link" then
			dest_node = selected_node
		elseif node_type == "inline_link" then
			dest_node = selected_node:named_child(1)
		elseif node_type == "link_text" then
			local parent_node = selected_node:parent()
			if parent_node then
				local parent_node_type = parent_node:type()
				-- vim.notify("parent_node_type: " .. parent_node_type, vim.log.levels.debug)
				if parent_node_type == "inline_link" then
					dest_node = selected_node:next_named_sibling()
				elseif parent_node_type == "shortcut_link" then
					dest_node = selected_node
				end
			end
		end

		if dest_node then
			url = vim.treesitter.get_node_text(dest_node, 0)
		else
			vim.notify("No valid link destination found!", vim.log.levels.WARN)
			return
		end
	else
		url = vim.fn.expand("<cWORD>")
	end

	if url == "" then
		vim.notify("No valid URL found!", vim.log.levels.WARN)
		return
	end

	-- Excalidraw integration
	-- /home/xi3k/Development/Neovim/simachri/qol-md-extensions.nvim/lua/qol-md-extensions/init.lua
	if string.match(url, "%.excalidraw$") then
		local clean_file = url
		clean_file = string.gsub(clean_file, "%[%[(.*)%]%]", "%1")
		clean_file = string.gsub(clean_file, "!%[(.*)%]", "%1")

		local notes_root = vim.fn.expand("$HOME/Notes/.excalidraw")
		local full_path = notes_root .. "/" .. clean_file

		-- vim.notify("Excalidraw file path: " .. full_path, vim.log.levels.debug)

		if vim.fn.filereadable(full_path) == 1 then
			-- Open in VSCode
			vim.system({ '/mnt/c/Program Files/Microsoft VS Code/Code.exe', full_path })
			print("Opening " .. clean_file .. " in VSCode...")
		else
			print("File not found: " .. full_path)
		end

		return true
	end

	-- vim.notify("url: " .. url, vim.log.levels.debug)

	-- vim.keymap.set("n", "gx", ":call system('www-browser <C-r><C-a>')<CR>", { silent = true })
	-- vim.notify(
	-- 	"final command: " .. "call system(\"www-browser " .. vim.fn.shellescape(url) .. "\")",
	-- 	vim.log.levels.debug
	-- )
	vim.cmd('call system("www-browser ' .. vim.fn.shellescape(url) .. '")')
end

return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		config = function()
			require("render-markdown").setup({
				file_types = { "markdown", "Avante" },

				render_modes = true, -- render in all modes

				heading = {
					-- disable sign column related rendering
					sign = false,
					-- disable icons for headers
					-- icons = false,
					-- -- disable backgrounds
					-- backgrounds = false,
					-- do not cover the whole window with with the header background
					width = "block",
					-- min_width = 89,
					-- -- left_pad = 2,
					right_pad = 2,
					-- disable setext header rendering
					setext = false,
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
					custom = {
						question = {
							raw = "[?]",
							rendered = "??",
							highlight = "RenderMarkdownWarn",
							scope_highlight = nil,
						},
						decision = {
							raw = "[!]",
							rendered = "!!",
							highlight = "RenderMarkdownError",
							scope_highlight = nil,
						},
						information = {
							raw = "[i]",
							rendered = "Info",
							highlight = "RenderMarkdownHint",
							scope_highlight = nil,
						},
					},
				},
				dash = {
					enabled = false,
					-- width = 15,
				},
				link = {
					wiki = { icon = "↪ " },
				},
			})

			-- -- Only have headings to be underlined instead of actual background.
			-- vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { underdouble = true, bold = true })
			-- vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { underdouble = true, bold = true })
			-- vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { underdouble = true, bold = true })
			-- vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { underdouble = true, bold = true })
			-- vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", { underdouble = true, bold = true })
			-- vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", { underdouble = true, bold = true })
		end,

		ft = { "markdown", "Avante" },
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }, -- if you use standalone mini plugins
	},

	{
		-- 2025-02-14: Disabling this as I am using this plugin only for jumping to next
		-- header and next link.
		"jakewvincent/mkdnflow.nvim",
		ft = { "markdown" },
		enabled = true,
		keys = {
			{ "]r", "<cmd>MkdnNextLink<cr>", desc = "Next Markdown link" },
			{ "[r", "<cmd>MkdnPrevLink<cr>", desc = "Previous Markdown link" },
		},
		config = function()
			require("mkdnflow").setup({
				modules = {
					bib = false,
					buffers = false,
					-- 2024-07-26, disable conceal because of markdown.nvim
					conceal = false,
					cursor = true, -- used for jump to next link
					folds = false,
					links = true, -- used for jump to next link
					lists = false,
					maps = false, -- keymaps
					paths = false,
					tables = false,
				},
				cursor = {
					jump_patterns = {
						"(%b[]%b())", -- markdown link
						"(%[%b[]%])", -- wiki link
					},
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
					-- use absolute file path to allow .md files to be moved around.
					dir_path = "/home/xi3k/Notes/.img", ---@type string | fun(): string
					extension = "png", ---@type string | fun(): string
					-- file_name = "%Y-%m-%d-%H-%M-%S", ---@type string | fun(): string
					-- https://github.com/HakonHarnes/img-clip.nvim/issues/76#issuecomment-2154444847
					file_name = function()
						local desc_input = vim.fn.input("Description: ")
						local desc_sanitized = desc_input:lower():gsub("[^a-z0-9]", "-")
						local timestamp = os.date("%Y-%m-%d-%H-%M-%S")
						local file_name = desc_sanitized .. "-" .. timestamp
						return file_name
					end,
					prompt_for_file_name = false,
					use_absolute_path = true, ---@type boolean | fun(): boolean
					relative_to_current_file = false, ---@type boolean | fun(): boolean
					url_encode_path = true, ---@type boolean | fun(): boolean
					template = "![$LABEL]($FILE_PATH)", ---@type string | fun(context: table): string
					download_images = false, ---@type boolean | fun(): boolean
				},
			},
		},
		keys = {
			{ "<leader>mpi", "<cmd>PasteImage<cr>", desc = "Markdown Paste Image from clipboard" },
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
			{ "<leader>mps", ":MarkdownPreview<CR>", { silent = true, desc = "Markdown Preview Start" } },
			{ "<leader>mpc", ":MarkdownPreviewStop<CR>", { silent = true, desc = "Markdown Preview Cancel" } },
		},
	},
}
