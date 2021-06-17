-- https://github.com/ThePrimeagen/harpoon
require("harpoon").setup({
    global_settings = {
        save_on_toggle = false,
        save_on_change = true,
    },
})

-- """""""""""""""""""""""""""""
-- Keymappings
-- """""""""""""""""""""""""""""
-- 'harpoon add': Add file mark.
vim.api.nvim_set_keymap("n", "<Leader>ha", "<Cmd>lua require('harpoon.mark').add_file()<CR>", { noremap = true, silent = true })
-- 'harpoon list': Show file marks.
vim.api.nvim_set_keymap("n", "<Leader>hl", "<Cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", { noremap = true, silent = true })
