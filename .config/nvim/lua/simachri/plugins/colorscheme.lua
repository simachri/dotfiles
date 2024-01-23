return {
	{
		"simachri/nvim-solarized-lua",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		init = function()
			vim.opt.background = "light"
			vim.cmd("colorscheme solarized-flat")
		end,
	},
}
