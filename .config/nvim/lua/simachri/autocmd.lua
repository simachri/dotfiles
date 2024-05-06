vim.api.nvim_create_autocmd("BufWinLeave", {
	pattern = "*.*",
	callback = function()
		-- disable for Java as it raises an error due to jdtls
		if vim.bo.filetype == "java" then
			return
		end

		vim.cmd("silent! mkview")
	end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*.*",
	callback = function()
		-- disable for Java as it raises an error due to jdtls
		if vim.bo.filetype == "java" then
			return
		end

		vim.cmd("silent! loadview")
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "java",
	command = "lua require'simachri.jdtls'.setup()",
})
