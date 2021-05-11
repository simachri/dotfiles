" Example configuration: https://github.com/puremourning/vimspector/blob/master/support/custom_ui_vimrc
" setup boilerplate to make this file usable with vim -Nu <tihs file> {{{

let g:vimspector_install_gadgets = [ 'debugpy' ]

function! s:SwitchConsoleToStdErr()
  execute 'VimspectorShowOutput stderr'
  " Go back to 'code' window.
  call win_gotoid(g:vimspector_session_windows.code)
endfunction

augroup CustomizeUI
  autocmd!
  " Switch the console window to stderr.
  " NOTE: Does not yet work for some reason.
  autocmd User VimspectorUICreated call s:SwitchConsoleToStdErr()
augroup END

"let s:maximized = 0
"fun! GotoWindow(id, maximize)
  "call win_gotoid(a:id)
  "if a:maximize && s:maximized == 0
    "" Currently not maximized -> maximize!
    "MaximizerToggle
    "let s:maximized = 1
  "elseif a:maximize == 0 && s:maximized
    "" Maximized -> undo!
    "MaximizerToggle
    "let s:maximized = 0
  "endif
"endfun

" Debugger remaps
nnoremap <leader>m :MaximizerToggle!<CR>
nnoremap <leader>dd :call vimspector#Launch()<CR>
nnoremap <leader>dc :call win_gotoid(g:vimspector_session_windows.code)<CR>
nnoremap <leader>dt :call win_gotoid(g:vimspector_session_windows.tagpage)<CR>
nnoremap <leader>dv :call win_gotoid(g:vimspector_session_windows.variables)<CR>
nnoremap <leader>dw :call win_gotoid(g:vimspector_session_windows.watches)<CR>
nnoremap <leader>ds :call win_gotoid(g:vimspector_session_windows.stack_trace)<CR>
" Play in console
nnoremap <leader>dp :VimspectorShowOutput Console<CR>
" Output: Show console errors
nnoremap <leader>de :VimspectorShowOutput stderr<CR>
" for normal mode - the word under the cursor
nnoremap <Leader>di <Plug>VimspectorBalloonEval
" for visual mode, the visually selected text
xnoremap <Leader>di <Plug>VimspectorBalloonEval
nnoremap <leader>dq :call vimspector#Reset()<CR>

nmap <leader>dl <Plug>VimspectorStepInto
nmap <leader>dj <Plug>VimspectorStepOver
nmap <leader>dh <Plug>VimspectorStepOut
nmap <leader>d_ <Plug>VimspectorRestart
nnoremap <leader>d<space> :call vimspector#Continue()<CR>

nmap <leader>drc <Plug>VimspectorRunToCursor
nmap <leader>dbp <Plug>VimspectorToggleBreakpoint
nmap <leader>dbc <Plug>VimspectorToggleConditionalBreakpoint
