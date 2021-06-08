" https://github.com/voldikss/vim-floaterm

let g:floaterm_width = 0.9
let g:floaterm_height = 0.9
let g:floaterm_opener = 'edit'

" Toggle terminal
nnoremap <silent> <Leader>tt :FloatermToggle zsh<CR>
" Hide terminal, it will be running in the background.
tnoremap <silent> <C-d> <C-\><C-n>:FloatermToggle zsh<CR>
tnoremap <silent> <C-S-d> <C-\><C-n>:FloatermKill!<CR>

" Open lazygit
nnoremap <silent> <Leader>lg :FloatermNew --autoclose=2 lazygit<CR>

" Open taskwarrior-tui
nnoremap <silent> <Leader>tw :FloatermNew --autoclose=1 --disposable taskwarrior-tui<CR>

""""""""""""""""""""""""""""""""""""""
" Auto commands
""""""""""""""""""""""""""""""""""""""
augroup floatermHooks
  au!
  "au User FloatermOpen nmap <buffer><silent> gf echo("hello")
augroup END
