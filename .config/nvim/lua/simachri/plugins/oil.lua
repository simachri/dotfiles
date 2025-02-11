return {
	"stevearc/oil.nvim",
	config = function()
		require("oil").setup({
			-- Show files and directories that start with "."
			show_hidden = true,
		})


      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      vim.keymap.set("n", "_", "<CMD>Oil .<CR>", { desc = "Open CWD" })
	end,

}
