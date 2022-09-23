" https://github.com/mcchrish/nnn.vim
" NNN opener
" Disable default mappings
let g:nnn#set_default_mappings = 0
let g:nnn#layout = { 'window': { 'width': 0.8, 'height': 0.8, 'highlight': 'Debug' } }
let g:nnn#action = {
      \ '<c-x>': 'split',
      \ '<c-v>': 'vsplit' }
" -P p: Start plugin preview-tui on nnn startup.
" -a: Auto NNN_FIFO
" -o: Open files only on enter
" -e: Use $EDITOR to open text files.
" -D: Set colors for directories using NNN_FCOLORS
" -H: Show hidden files.
" -A: Disable auto enter directory on unique filter match
let g:nnn#command = 'nnn -aeDHA'

" Open NNN in Vim's CWD.
nnoremap <silent> <Leader>nn :NnnPicker<CR>
" Open NNN in current buffer's directory.
nnoremap <silent> <Leader>nf :NnnPicker %:p:h<CR>
