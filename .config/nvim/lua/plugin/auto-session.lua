require("persistence").setup({
  dir = vim.fn.expand(vim.fn.stdpath("config") .. "/sessions/"), -- directory where session files are saved
  options = { "buffers", "curdir", "tabpages", "winsize" }, -- sessionoptions used for saving
})
vim.api.nvim_set_keymap("n", "<Leader>sr", [[<cmd>lua require("persistence").load()<cr>]], {})

-- 2022-09-16: Removed auto-session in favpr of folke/persistence.nvim
---- https://github.com/rmagatti/auto-session
---- 21-07-31: The key remapping is required to suppress
---- a 'bwipe 1' error when restoring a session.
--vim.api.nvim_set_keymap("n", "<Leader>sr", "<cmd>silent! RestoreSession<CR>", {})
--local opts = {
  --log_level = 'error',
  --auto_session_enable_last_session = false,
  --auto_session_root_dir = "/home/xi3k/.config/nvim/sessions/",
  --auto_session_enabled = true,
  --auto_save_enabled = true,
  --auto_restore_enabled = false,
  --auto_session_suppress_dirs = nil,
  ---- For some reason, scrolloff is set to 0 when a session is restored.
  --post_restore_cmds = {"set scrolloff=8"}
--}
--require('auto-session').setup(opts)
