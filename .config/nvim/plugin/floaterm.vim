" https://github.com/voldikss/vim-floaterm

let g:floaterm_width = 0.9
let g:floaterm_height = 0.9
" By default, open a file as a new buffer in the existing Neovim instance
" when using the 'floaterm' command on the commandline.
let g:floaterm_opener = 'edit'

" Toggle terminal
nnoremap <silent> <Leader>tt :FloatermToggle --name shell zsh<CR>
" Hide terminal, it will be running in the background.
tnoremap <silent> <C-d> <C-\><C-n>:FloatermToggle zsh<CR>
tnoremap <silent> <C-S-d> <C-\><C-n>:FloatermKill!<CR>

" Open lazygit
" --disposable: Prevents memory leakage.
nnoremap <silent> <Leader>lg :FloatermNew --autoclose=2 --name=lazygit --disposable lazygit<CR>

" Open taskwarrior-tui
" --disposable: Prevents memory leakage.
" --opener: The command when 'floaterm' is used.
function! OpenTwTask(arg)
    let path_and_heading = split(a:arg, "@")
    let heading = "# " . substitute(path_and_heading[1], "_", " ", "g")
    exec 'edit ' . path_and_heading[0]
    exec 'normal i' . heading
    " Add two new lines under the heading.
    exec 'normal A'
endfunction
command! -nargs=1 OpenTwTask call OpenTwTask(<q-args>)
nnoremap <silent> <Leader>tw :FloatermNew --autoclose=2 --name=tw --disposable --opener=OpenTwTask taskwarrior-tui<CR>

""""""""""""""""""""""""""""""""""""""
" Auto commands
""""""""""""""""""""""""""""""""""""""
augroup floatermHooks
  au!
  "au User FloatermOpen nmap <buffer><silent> gf echo("hello")
augroup END

