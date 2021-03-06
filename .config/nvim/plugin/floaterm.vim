" https://github.com/voldikss/vim-floaterm

let g:floaterm_width = 0.9
let g:floaterm_height = 0.9
" By default, open a file as a new buffer in the existing Neovim instance
" when using the 'floaterm' command on the commandline.
let g:floaterm_opener = 'edit'

" Toggle terminal
nnoremap <silent> <Leader>tt :FloatermToggle zsh<CR>
" Hide terminal, it will be running in the background.
tnoremap <silent> <C-d> <C-\><C-n>:FloatermToggle<CR>
tnoremap <silent> <C-S-d> <C-\><C-n>:FloatermKill!<CR>

" Open lazygit
" --disposable: Prevents memory leakage.
nnoremap <silent> <Leader>lg :FloatermNew --autoclose=2 --name=lazygit --disposable lazygit<CR>

" Open taskwarrior-tui
" --disposable: Prevents memory leakage.
" --opener: The command when 'floaterm' is used.
function! OpenTwTask(arg)
    " Kill the floaterm instance to prevent memory leakage.
    exec 'FloatermKill tw'
    let path_and_heading = split(a:arg, "@")
    exec 'edit ' . path_and_heading[0]
    " Return, if the description is empty.
    if len(path_and_heading) == 1
      return
    endif
    let heading = "# " . substitute(path_and_heading[1], "_", " ", "g")
    exec 'normal i' . heading
    " Add two new lines under the heading.
    exec 'normal A'
endfunction
command! -nargs=1 OpenTwTask call OpenTwTask(<q-args>)

let g:twtui_term_launched = 0
function! OpenTwTuiFloaterm()
  if g:twtui_term_launched
    FloatermToggle tw
  else
    FloatermNew --name=tw --autoclose=0 --opener=OpenTwTask taskwarrior-tui
    let g:twtui_term_launched = 1
  endif
endfunction
command! OpenTwTuiFloaterm call OpenTwTuiFloaterm()
" 21-06-15 Keeping the taskwarrior-tui instance running
" leads to high nvim CPU usage. So we close it everytime.
"nnoremap <silent> <Leader>tw :OpenTwTuiFloaterm<CR>
" FIXME: --disposable leads to an issue that :bdelete does not work if the shortcut 1 is 
" used to edit the notes of a task.
" Workaround: Go without --disposable and always quit taskwarrior using 'q'.
"nnoremap <silent> <Leader>tw :FloatermNew --autoclose=2 --name=tw --disposable --opener=OpenTwTask taskwarrior-tui<CR>
nnoremap <silent> <Leader>tw :FloatermNew --autoclose=2 --name=tw --opener=OpenTwTask taskwarrior-tui<CR>

""""""""""""""""""""""""""""""""""""""
" Auto commands
""""""""""""""""""""""""""""""""""""""
augroup floatermHooks
  au!
  "au User FloatermOpen nmap <buffer><silent> gf echo("hello")
augroup END

