-- Current buffer fuzzy find
vim.api.nvim_buf_set_keymap(0, 'n', '<leader>fs', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>]], { noremap = true, silent = true })
