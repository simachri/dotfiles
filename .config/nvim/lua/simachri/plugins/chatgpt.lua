return {
	{
		"jackMort/ChatGPT.nvim",
    event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{ "<leader>tk", ":ChatGPT<CR>", { silent = true } },
		},
		opts = {
			chat = {
				keymaps = {
					-- close = { "<C-c>" },
					close = "<C-q>",
					yank_last = "<C-y>",
					yank_last_code = "<C-k>",
					scroll_up = "<C-u>",
					scroll_down = "<C-d>",
					toggle_settings = "<C-o>",
					new_session = "<C-n>",
					cycle_windows = "<Tab>",
					select_session = "<Space>",
					rename_session = "r",
					delete_session = "d",
				},
			},
			popup_input = {
				-- submit = "<C-Enter>",
				submit = "<Enter>",
			},
		},
	},
}
