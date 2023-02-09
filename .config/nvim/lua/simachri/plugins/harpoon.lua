return {
	{
		"ThePrimeagen/harpoon",
		keys = {
			{ "<Leader>jk", "<Cmd>lua require('harpoon.mark').add_file()<CR>", { noremap = true, silent = true } },
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
		opts = {
			global_settings = {
				save_on_toggle = true,
				save_on_change = true,
			},
			menu = {
				width = 100,
			},
		},
	},
}
