return {
    {
        -- https://github.com/rmagatti/auto-session
        'rmagatti/auto-session',
        keys = {
            { '<leader>sr', '<cmd>silent! RestoreSession<CR>', { noremap = true, silent = true } },
        },
        opts = {
            log_level = 'error',
            auto_session_enable_last_session = false,
            auto_session_root_dir = "/home/xi3k/.config/nvim/sessions/",
            auto_session_enabled = true,
            auto_save_enabled = true,
            auto_restore_enabled = false,
            auto_session_suppress_dirs = {'~/.config/nvim/plugged/*'},
            -- For some reason, scrolloff is set to 0 when a session is restored.
            post_restore_cmds = {"set scrolloff=8"},
            cwd_change_handling = {
                restore_upcoming_session = false, -- already the default, no need to specify like this, only here as an example
                pre_cwd_changed_hook = nil, -- already the default, no need to specify like this, only here as an example
                post_cwd_changed_hook = nil,
            },
        },
        init = function ()
            vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
        end
    },
}
