" Use treesitter for folding
" https://github.com/nvim-treesitter/nvim-treesitter
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" https://github.com/rafi/vim-venom#configuration
" Do not automatically activate virtual environments.
let g:venom_auto_activate=0

" Activate python formatter
" https://github.com/sbdchd/neoformat
let g:neoformat_enabled_python= ['autopep8']

""""""""""""""""""""""""""""""""""""""
" Auto commands
""""""""""""""""""""""""""""""""""""""
augroup pythonFiletypeHooks
  au!
  " Automatically restart LSP once a virtual enviornment has been activated.
  au User VenomActivated LspRestart
augroup END

""""""""""""""""""""""""""""""""""""""
" Keymaps
""""""""""""""""""""""""""""""""""""""
" 'Add import' for word under cursor.
" Works only if it has been already imported in another project file.
nnoremap <leader>ai <plug>ApyroriInsert

" It is set to 2 for some reason. Currently unknown where this comes from.
set conceallevel=0
