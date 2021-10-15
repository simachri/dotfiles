-- https://github.com/ThePrimeagen/harpoon
require("harpoon").setup({
    global_settings = {
        save_on_toggle = true,
        save_on_change = true,
    },
    menu = {
      width = 100,
    }
})

-- """""""""""""""""""""""""""""
-- Keymappings
-- """""""""""""""""""""""""""""
-- Add mark
vim.api.nvim_set_keymap("n", "<Leader>hh", "<Cmd>lua require('harpoon.mark').add_file()<CR>", { noremap = true, silent = true })
-- Show marks
vim.api.nvim_set_keymap("n", "<C-y>", "<Cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", { noremap = true, silent = true })
-- Jump to mark 1 - 3
vim.api.nvim_set_keymap("n", "<Leader>ha", "<Cmd>lua require('harpoon.ui').nav_file(1)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>hs", "<Cmd>lua require('harpoon.ui').nav_file(2)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>hd", "<Cmd>lua require('harpoon.ui').nav_file(3)<CR>", { noremap = true, silent = true })
