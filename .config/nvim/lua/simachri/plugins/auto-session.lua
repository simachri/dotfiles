return {
	{
		-- https://github.com/rmagatti/auto-session
		"rmagatti/auto-session",
		lazy = false,
		keys = {
			{ "<leader>sr", "<cmd>silent! SessionRestore<CR>", { noremap = true, silent = true } },
		},
		opts = {
			auto_restore = false,
			auto_restore_last_session = false,
			auto_save = true,
			cwd_change_handling = {
				restore_upcoming_session = false,
			},
			enabled = true,
			log_level = "error",
			post_restore_cmds = { "set scrolloff=8" },
			root_dir = "/home/xi3k/.config/nvim/sessions/",
			suppressed_dirs = { "~/.config/nvim/plugged/*" },
		},
		init = function()
			vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
		end,
	},
}
