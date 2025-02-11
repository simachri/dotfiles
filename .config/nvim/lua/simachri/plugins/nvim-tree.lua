local function custom_keymappings(bufnr)
	local api = require("nvim-tree.api")

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	local function edit_or_open()
		local node = api.tree.get_node_under_cursor()

		if node.nodes ~= nil then
			-- expand or collapse folder
			api.node.open.edit()
		else
			-- open file
			api.node.open.edit()
			-- Close the tree if file was opened
			api.tree.close()
		end
	end

	-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Migrating-To-on_attach
	-- vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node,          opts('CD'))
	vim.keymap.set("n", "<C-g>", api.tree.change_root_to_node, opts("CD"))
	vim.keymap.set("n", "<C-e>", api.node.open.replace_tree_buffer, opts("Open: In Place"))
	vim.keymap.set("n", "<C-k>", api.node.show_info_popup, opts("Info"))
	vim.keymap.set("n", "<C-r>", api.fs.rename_sub, opts("Rename: Omit Filename"))
	vim.keymap.set("n", "<C-t>", api.node.open.tab, opts("Open: New Tab"))
	vim.keymap.set("n", "<C-v>", api.node.open.vertical, opts("Open: Vertical Split"))
	vim.keymap.set("n", "<C-x>", api.node.open.horizontal, opts("Open: Horizontal Split"))
	vim.keymap.set("n", "<BS>", api.node.navigate.parent_close, opts("Close Directory"))
	vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
	vim.keymap.set("n", "<Tab>", api.node.open.preview, opts("Open Preview"))
	vim.keymap.set("n", ">", api.node.navigate.sibling.next, opts("Next Sibling"))
	vim.keymap.set("n", "<", api.node.navigate.sibling.prev, opts("Previous Sibling"))
	vim.keymap.set("n", ".", api.node.run.cmd, opts("Run Command"))
	vim.keymap.set("n", "-", api.tree.change_root_to_parent, opts("Up"))
	-- vim.keymap.set('n', 'a',     api.fs.create,                         opts('Create'))
	vim.keymap.set("n", "n", api.fs.create, opts("Create"))
	vim.keymap.set("n", "bmv", api.marks.bulk.move, opts("Move Bookmarked"))
	vim.keymap.set("n", "B", api.tree.toggle_no_buffer_filter, opts("Toggle No Buffer"))
	vim.keymap.set("n", "y", api.fs.copy.node, opts("Copy"))
	vim.keymap.set("n", "Y", api.fs.copy.absolute_path, opts("Copy Absolute Path"))
	-- vim.keymap.set('n', 'c',     api.fs.copy.node,                      opts('Copy'))
	-- vim.keymap.set('n', 'C',     api.tree.toggle_git_clean_filter,      opts('Toggle Git Clean'))
	vim.keymap.set("n", "[c", api.node.navigate.git.prev, opts("Prev Git"))
	vim.keymap.set("n", "]c", api.node.navigate.git.next, opts("Next Git"))
	-- vim.keymap.set('n', 'd',     api.fs.remove,                         opts('Delete'))
	vim.keymap.set("n", "x", api.fs.remove, opts("Delete"))
	vim.keymap.set("n", "D", api.fs.trash, opts("Trash"))
	vim.keymap.set("n", "E", api.tree.expand_all, opts("Expand All"))
	vim.keymap.set("n", "e", api.fs.rename_basename, opts("Rename: Basename"))
	vim.keymap.set("n", "]e", api.node.navigate.diagnostics.next, opts("Next Diagnostic"))
	vim.keymap.set("n", "[e", api.node.navigate.diagnostics.prev, opts("Prev Diagnostic"))
	vim.keymap.set("n", "F", api.live_filter.clear, opts("Clean Filter"))
	vim.keymap.set("n", "f", api.live_filter.start, opts("Filter"))
	vim.keymap.set("n", "g?", api.tree.toggle_help, opts("Help"))
	vim.keymap.set("n", "gy", api.fs.copy.absolute_path, opts("Copy Absolute Path"))
	vim.keymap.set("n", "h", api.tree.change_root_to_parent, opts("Change Root To Parent"))
	vim.keymap.set("n", "H", api.tree.toggle_hidden_filter, opts("Toggle Dotfiles"))
	vim.keymap.set("n", "I", api.tree.toggle_gitignore_filter, opts("Toggle Git Ignore"))
	vim.keymap.set("n", "J", api.node.navigate.sibling.last, opts("Last Sibling"))
	vim.keymap.set("n", "K", api.node.navigate.sibling.first, opts("First Sibling"))
	vim.keymap.set("n", "l", edit_or_open, opts("Edit Or Open"))
	vim.keymap.set("n", "m", api.marks.toggle, opts("Toggle Bookmark"))
	vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
	vim.keymap.set("n", "O", api.node.open.no_window_picker, opts("Open: No Window Picker"))
	vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
	vim.keymap.set("n", "P", api.node.navigate.parent, opts("Parent Directory"))
	-- vim.keymap.set('n', 'q',     api.tree.close,                        opts('Close'))
	vim.keymap.set("n", "<C-q>", api.tree.close, opts("Close"))
	vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
	vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
	vim.keymap.set("n", "s", api.node.run.system, opts("Run System"))
	vim.keymap.set("n", "S", api.tree.search_node, opts("Search"))
	vim.keymap.set("n", "U", api.tree.toggle_custom_filter, opts("Toggle Hidden"))
	vim.keymap.set("n", "W", api.tree.collapse_all, opts("Collapse"))
	vim.keymap.set("n", "d", api.fs.cut, opts("Cut"))
	-- vim.keymap.set('n', 'y',     api.fs.copy.filename,                  opts('Copy Name'))
	-- vim.keymap.set('n', 'Y',     api.fs.copy.relative_path,             opts('Copy Relative Path'))
	vim.keymap.set("n", "c", api.fs.copy.filename, opts("Copy Name"))
	vim.keymap.set("n", "C", api.fs.copy.relative_path, opts("Copy Relative Path"))
	vim.keymap.set("n", "<2-LeftMouse>", api.node.open.edit, opts("Open"))
	vim.keymap.set("n", "<2-RightMouse>", api.tree.change_root_to_node, opts("CD"))
end
return {
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			"nvim-web-devicons",
		},
		keys = {
			{ "<leader>nn", "<cmd>NvimTreeToggle .<cr>", { noremap = true, silent = true } },
			{ "<leader>nq", "<cmd>NvimTreeClose<cr>", { noremap = true, silent = true } },
			{ "<leader>nf", "<cmd>NvimTreeToggle %:p:h<cr>", { noremap = true, silent = true } },
		},
		opts = {
			on_attach = custom_keymappings,
			view = {
				float = {
					enable = true,
					quit_on_focus_loss = true,
					open_win_config = function()
						local screen_w = vim.opt.columns:get()
						local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
						local _width = screen_w * 0.7
						local _height = screen_h * 0.8
						local width = math.floor(_width)
						local height = math.floor(_height)
						local center_y = ((vim.opt.lines:get() - _height) / 2) - vim.opt.cmdheight:get()
						local center_x = (screen_w - _width) / 2
						local layouts = {
							center = {
								anchor = "NW",
								relative = "editor",
								border = "single",
								row = center_y,
								col = center_x,
								width = width,
								height = height,
							},
						}
						return layouts.center
					end,
				},
			},
			live_filter = {
				prefix = "[FILTER]: ",
				always_show_folders = false,
			},
			actions = {
				change_dir = {
					enable = true,
					-- global = true, -- use :cd instead of :lcd
					restrict_above_cwd = false,
				},
			},
		},
	},
}
