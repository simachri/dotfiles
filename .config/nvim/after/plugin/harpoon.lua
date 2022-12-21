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
vim.api.nvim_set_keymap("n", "<Leader>jk", "<Cmd>lua require('harpoon.mark').add_file()<CR>", { noremap = true, silent = true })
-- Show marks
vim.api.nvim_set_keymap("n", "<Leader>jl", "<Cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", { noremap = true, silent = true })
-- Jump to mark 1 - 4
vim.api.nvim_set_keymap("n", "<Leader>ja", "<Cmd>lua require('harpoon.ui').nav_file(1)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>js", "<Cmd>lua require('harpoon.ui').nav_file(2)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>jd", "<Cmd>lua require('harpoon.ui').nav_file(3)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>jf", "<Cmd>lua require('harpoon.ui').nav_file(4)<CR>", { noremap = true, silent = true })
