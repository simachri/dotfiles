" https://github.com/voldikss/vim-floaterm

let g:floaterm_width = 0.9
let g:floaterm_height = 0.9

" Toggle terminal
nnoremap <silent> <Leader>tt :FloatermToggle<CR>
" Hide terminal, it will be running in the background.
tnoremap <silent> <C-d> <C-\><C-n>:FloatermToggle<CR>
tnoremap <silent> <C-S-d> <C-\><C-n>:FloatermKill<CR>
