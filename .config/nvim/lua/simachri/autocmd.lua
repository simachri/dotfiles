vim.api.nvim_create_autocmd(
	"BufWinLeave",
	{
		pattern = "*.*",
		callback = function() vim.cmd.mkview() end,
	}
)

vim.api.nvim_create_autocmd(
	"BufWinEnter",
	{
		pattern = "*.*",
		command = "silent! loadview",
	}
)
