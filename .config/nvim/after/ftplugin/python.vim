" Use treesitter for folding
" https://github.com/nvim-treesitter/nvim-treesitter
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

""""""""""""""""""""""""""""""""""""""
" Keymaps
""""""""""""""""""""""""""""""""""""""
" Open outline - is the same as "find header" for markdown files.
" Provided by plugin https://github.com/simrat39/symbols-outline.nvim
noremap <buffer> <Leader>fh :SymbolsOutline<CR>
" 'Add import' for word under cursor.
" Works only if it has been already imported in another project file.
nnoremap <leader>ai <plug>ApyroriInsert
