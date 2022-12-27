-- https://github.com/rmagatti/auto-session
-- 21-07-31: The key remapping is required to suppress
-- a 'bwipe 1' error when restoring a session.
-- 22-12-27: Seems to be fixed.
vim.api.nvim_set_keymap("n", "<Leader>sr", "<cmd>silent! RestoreSession<CR>", {})
local opts = {
  log_level = 'error',
  auto_session_enable_last_session = false,
  auto_session_root_dir = "/home/xi3k/.config/nvim/sessions/",
  auto_session_enabled = true,
  auto_save_enabled = true,
  auto_restore_enabled = true,
  auto_session_suppress_dirs = {'~/.config/nvim/plugged/*'},
  -- For some reason, scrolloff is set to 0 when a session is restored.
  post_restore_cmds = {"set scrolloff=8"},
  cwd_change_handling = {
    restore_upcoming_session = false, -- already the default, no need to specify like this, only here as an example
    pre_cwd_changed_hook = nil, -- already the default, no need to specify like this, only here as an example
    post_cwd_changed_hook = nil,
  },
}
require('auto-session').setup(opts)

vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
