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

--  https://github.com/folke/snacks.nvim/blob/main/docs/rename.md#oilnvim
vim.api.nvim_create_autocmd("User", {
  pattern = "OilActionsPost",
  callback = function(event)
      if event.data.actions.type == "move" then
          Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
      end
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
    pattern = "*.md",
    desc = 'Enable todo-comments for text',
    group = vim.api.nvim_create_augroup('user.todo.text', { clear = true }),
    callback = function(ev)
        local config = require 'todo-comments.config'
        local comments_only = string.match(ev.file, '%.md$') == nil
            and string.match(ev.file, '%.txt$') == nil
            and string.match(ev.file, '%.adoc$') == nil
            and string.match(ev.file, '%.asciidoc$') == nil
        config.options.highlight.comments_only = comments_only
    end,
})

