return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")
			-- local Logger = require("harpoon.logger")
			-- local Path = require("plenary.path")
			-- local function normalize_path(buf_name, root)
			-- 	return Path:new(buf_name):make_relative(root)
			-- end

			-- REQUIRED
			harpoon:setup({

				settings = {
					save_on_toggle = true,
					save_on_change = true,
					key = function()
						return vim.loop.cwd()
					end,
				},

				-- 	default = {
				-- 		-- default: https://github.com/ThePrimeagen/harpoon/blob/harpoon2/lua/harpoon/config.lua
				-- 		create_list_item = function(config, name)
				-- 			name = name
				-- 				-- TODO: should we do path normalization???
				-- 				-- i know i have seen sometimes it becoming an absolute
				-- 				-- path, if that is the case we can use the context to
				-- 				-- store the bufname and then have value be the normalized
				-- 				-- value
				-- 				or normalize_path(
				-- 					vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()),
				-- 					config.get_root_dir()
				-- 				)
				--
				-- 			Logger:log("config_default#create_list_item", name)
				--
				-- 			-- adjustment: Replace home directory with ~
				-- 			if Path:new(name):is_absolute() then
				--            Logger:log("config_default#create_list_item#path_is_absolute", name)
				-- 				name = vim.fn.expand("%:p:~")
				--            Logger:log("config_default#create_list_item#replaced_home_directory_with_tilde", name)
				-- 			end
				--
				-- 			local bufnr = vim.fn.bufnr(name, false)
				--
				-- 			local pos = { 1, 0 }
				-- 			if bufnr ~= -1 then
				-- 				pos = vim.api.nvim_win_get_cursor(0)
				-- 			end
				--
				-- 			return {
				-- 				value = name,
				-- 				context = {
				-- 					row = pos[1],
				-- 					col = pos[2],
				-- 				},
				-- 			}
				-- 		end,
				-- 	},
			})

			-- REQUIRED

			vim.keymap.set("n", "<leader>jk", function()
				harpoon:list():add()
			end)
			vim.keymap.set("n", "<leader>jl", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end)

			vim.keymap.set("n", "<leader>ja", function()
				harpoon:list():select(1)
			end)
			vim.keymap.set("n", "<leader>js", function()
				harpoon:list():select(2)
			end)
			vim.keymap.set("n", "<leader>jd", function()
				harpoon:list():select(3)
			end)
			vim.keymap.set("n", "<leader>jf", function()
				harpoon:list():select(4)
			end)

			vim.keymap.set("n", "<leader>jL", function()
                vim.cmd('edit ' .. vim.fn.expand('~/.tmux_harpoon'))
			end)
			--
			-- -- Toggle previous & next buffers stored within Harpoon list
			-- vim.keymap.set("n", "<C-S-P>", function()
			-- 	harpoon:list():prev()
			-- end)
			-- vim.keymap.set("n", "<C-S-N>", function()
			-- 	harpoon:list():next()
			-- end)
		end,
	},
}
