return {

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
		},
		event = { "BufReadPre", "BufNewFile" },
		keys = {
            -- should be available by default in nvim, see :h K-lsp-default
			{ "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true } },
            -- signature help is on Ctrl-s by default on insert and select mode since 
            -- nvim 0.11
			-- { "<leader>k", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { noremap = true, silent = true } },

			{ "grs", "<cmd>lua vim.diagnostic.open_float()<CR>", { noremap = true, silent = true } },

            -- default mapping since nvim 0.11
			-- { "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { noremap = true, silent = true } },
			-- { "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", { noremap = true, silent = true } },
			{ "<leader>ldq", "<cmd>lua vim.diagnostic.setloclist()<CR>", { noremap = true, silent = true } },
			{ "<leader>ldc", "<cmd>lua vim.diagnostic.disable()<CR>", { noremap = true, silent = true } },
			{ "<leader>lda", "<cmd>lua vim.diagnostic.enable()<CR>", { noremap = true, silent = true } },

			{ "<leader>lr", "<cmd>LspRestart<CR>", { noremap = true, silent = true } },

			-- https://github.com/folke/snacks.nvim/blob/main/docs/rename.md#snacksrenamerename_file
			{
				"<leader>rr",
				"<cmd>lua Snacks.rename.rename_file()<CR>",
				{ noremap = true, silent = true, desc = "Rename file" },
			},

			{ "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", { noremap = true, silent = true } },
			{ "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", { noremap = true, silent = true } },
			{
				"<space>wl",
				"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
				{ noremap = true, silent = true },
			},
		},
	},
}
