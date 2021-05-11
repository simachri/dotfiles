" Use treesitter for folding
" https://github.com/nvim-treesitter/nvim-treesitter
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" 'Add import' for word under cursor.
" Works only if it has been already imported in another project file.
nnoremap <leader>ai <plug>ApyroriInsert
