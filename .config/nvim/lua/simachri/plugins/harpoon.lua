return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<Leader>jk", "function() harpoon:list():append() end", { noremap = true, silent = true } },
			{
				"<Leader>jl",
				"<Cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>",
				{ noremap = true, silent = true },
			},
			{ "<Leader>ja", "<Cmd>lua require('harpoon.ui').nav_file(1)<CR>", { noremap = true, silent = true } },
			{ "<Leader>js", "<Cmd>lua require('harpoon.ui').nav_file(2)<CR>", { noremap = true, silent = true } },
			{ "<Leader>jd", "<Cmd>lua require('harpoon.ui').nav_file(3)<CR>", { noremap = true, silent = true } },
			{ "<Leader>jf", "<Cmd>lua require('harpoon.ui').nav_file(4)<CR>", { noremap = true, silent = true } },
		},
		config = function()
			local harpoon = require("harpoon")

			-- REQUIRED
			harpoon:setup()
			-- REQUIRED

			vim.keymap.set("n", "<leader>jk", function()
				harpoon:list():append()
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
			--
			-- -- Toggle previous & next buffers stored within Harpoon list
			-- vim.keymap.set("n", "<C-S-P>", function()
			-- 	harpoon:list():prev()
			-- end)
			-- vim.keymap.set("n", "<C-S-N>", function()
			-- 	harpoon:list():next()
			-- end)
		end,
		opts = {
			settings = {
				save_on_toggle = true,
				save_on_change = true,
				key = function()
					return vim.loop.cwd()
				end,
			},
		},
	},
}
