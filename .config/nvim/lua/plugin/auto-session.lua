-- https://github.com/rmagatti/auto-session
-- 21-07-31: The key remapping is required to suppress
-- a 'bwipe 1' error when restoring a session.
vim.api.nvim_set_keymap("n", "<Leader>rs", "<cmd>silent! RestoreSession<CR>", {})
local opts = {
  log_level = 'info',
  auto_session_enable_last_session = false,
  auto_session_root_dir = "/home/xi3k/.config/nvim/sessions/",
  auto_session_enabled = true,
  auto_save_enabled = true,
  auto_restore_enabled = false,
  auto_session_suppress_dirs = nil
}
require('auto-session').setup(opts)
