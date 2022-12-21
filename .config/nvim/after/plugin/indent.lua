-- https://github.com/lukas-reineke/indent-blankline.nvim
vim.g.indent_blankline_filetype_exclude = { 'markdown', 'taskedit', 'lspinfo', 'packer', 'checkhealth', 'help', '', }
vim.g.indent_blankline_show_first_indent_level = false
require("indent_blankline").setup {
    char_highlight_list = {
        "IndentBlanklineIndent1",
    },
}

vim.cmd([[
    highlight IndentBlanklineIndent1 guifg=#eee8d5 gui=nocombine
]])
-- This doesn't work:
-- vim.api.nvim_set_hl(0, 'IndentBlanklineIndent1', { fg = '#586e75', nocombine = true })
