" https://stackoverflow.com/a/446293
nnoremap <Space> <nop>
let mapleader=" "

"""""""""""
" Searching
""""""""""""
" Do not keep the last search result highlighted.
set nohlsearch
"" Highligh search by default.
""set hlsearch
" 'Toggle highlighted' search results
nnoremap <silent> <Leader>th :set hlsearch!<CR>
set incsearch
set ignorecase
set smartcase

""""""""""""""""""""""""""""""""
" Text format and editing styles
""""""""""""""""""""""""""""""""
" Do not set smartindent as it messes with # by putting it always on the first column.
" set smartindent
set autoindent
set backspace=2
" Folding
set foldmethod=indent   " fold based on indent
set foldnestmax=10      " deepest fold is 10 levels
set nofoldenable        " dont fold by default
set foldlevel=1 
set softtabstop=2
set shiftwidth=2
set shiftround
set expandtab
set textwidth=89   " width of document (used by gq)
" Show a vertical bar at column X - disabled as it is broken in VSCode and shows colored 
" blocks all over the place.
"set colorcolumn=90
" The following options have no effect when visual wrapping is disabled.
" set linebreak " Only break at the 'breakat' option 
" set breakindent
" set showbreak=>\
set fo=cMroqwnjl " see :help fo-table
set comments=s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-,fb:**
" set nowrap  " Disable 'visual' wrapping
" Wrap 10 columns before right margin is reached.
" wrapmargin has no effect if textwidth has a value other than zero, see the docs
set wrapmargin=10
" Indicate that a line has been wrapped.
let &showbreak = '>  '
" Use directory-specific .vimrc-files. They are sourced when opening a file in there.
set exrc
set secure
" Disable the mouse such that 'select-to-copy' works.
set mouse=

"""""""""""""""""""""
" Custom key mappings
"""""""""""""""""""""
" New mapping to not override the buffer when pasting.
" https://stackoverflow.com/a/3837845
xnoremap <Leader>p "_dP
" Prevent <leader><CR> to convert the word under cursor into a link (for some reason).
nnoremap <Leader><CR> <Esc>
"" Provided by plugin https://github.com/simrat39/symbols-outline.nvim
"nnoremap <silent> <Leader>to :SymbolsOutline<CR>
" Keymap to sync syntax highlighting again if it is broken.
" See :h redrawtime
nnoremap <silent> <Leader>e mx:e<CR>:syntax sync fromstart<CR>`x
" Jump to alternate file.
nnoremap <C-e> :b#<CR>
" Toggle spellchecking
nnoremap <leader>ts :setlocal spell!<CR>
" Undo breakpoints
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u
" Jumplist mutations when doing relative movement of more than five lines.
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'
" Keep the screen centered when using n & N for cycling through search results.
nnoremap n nzz
nnoremap N Nzz
" Quickfix window: Make <C-v> open the selected item in a vertical split.
" Source: https://stackoverflow.com/a/16743676
autocmd! FileType qf nnoremap <buffer> <C-v> <C-w><Enter><C-w>L
" Close current buffer
" command! Wd write|bdelete
" nnoremap <C-w>d :Wd<CR>
nnoremap <C-w>d :bd<CR>
" Close all buffers.
" The :silent! is used to omit the error message when
" terminals are running: E89
nnoremap <silent> <C-w>c :silent! %bd<CR>
" Close all buffers except for the current one.
" The bd# at the end deletes the [No Name] empty buffer.
" Source: https://stackoverflow.com/a/42071865
" The :silent! is used to omit the error message when
" terminals are running: E89
nnoremap <silent> <C-w>a mx:silent! %bd\|e#\|bd#<CR>`x
" Let Y yank to end of line instead of entire line.
nnoremap Y y$
"" Remove DOS line endings ^M 'reformat/remove m'
"nnoremap <silent> <Leader>rm :%s/\r//g<CR>
"" 'set filetype dosini'
"nnoremap <silent> <Leader>sd :%s/\r//g<CR>
set nowrap
" " Toggle wrap
" nnoremap <silent> <Leader>tw :set wrap!<CR>
" Allow saving of files as sudo when I forgot to start vim using sudo.
" nnoremap <leader>ww :!sudo tee > /dev/null %
" Simple insertion of blank lines
nnoremap <silent><C-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><C-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>
" x-mode is visual mode without select-mode. Otherwise this will override default <C-K>
xnoremap <silent><C-j> my<Esc>`>o<Esc>gv`y
xnoremap <silent><C-k> my<Esc>`<O<Esc>gv`y
"Jump to middle of line (remaps gm which jumps to middle of screen)
nnoremap gm :call cursor(0, len(getline('.'))/2)<CR>
" Formatting mappings
" Right alignment to column 90
nnoremap <Leader>> :right 90<CR>
vnoremap <Leader>> :'<,'>right 90<CR>
" 'Open' buffer in 'vertical' split
nnoremap <Leader>ov :vsp \| b
" Delete <DEL> in insert mode
imap <C-D> <Del>
" Insert single character
function! RepeatChar(char, count)
   return repeat(a:char, a:count)
endfunction
" 'refactor: replace word' word under cursor
nnoremap <silent> <Leader>rr :%s/\<<C-r><C-w>\>//gI<Left><Left><Left>
" Replace selection
vnoremap <silent> <Leader>rr "sy:%s/<C-r>s//gI<Left><Left><Left>
" Remap the join lines J command, such that the cursor remains at the position
" Source: https://stackoverflow.com/questions/9505198/join-two-lines-in-vim-without-moving-cursor
:nnoremap <silent> J :let p=getpos('.')<bar>join<bar>call setpos('.', p)<cr>
"" Set save key mapping.
"nnoremap <silent> <Leader>s :update!<CR>
"" Switch to next and previous buffer.
"nnoremap <C-H> :bp<CR>
"nnoremap <C-L> :bn<CR>
" 'Yank path': Yank the full filepath into the clipboard.
nnoremap <Leader>yp :let @+=expand('%:p')<CR>
" 'Yank CWD': Yank the current working directory into the clipboard.
nnoremap <Leader>yc :let @+=getcwd()<CR>
" Moving lines up and down
" 2020-12-18, Disable this as this somehow conflicts when using `ESCAPE` which causes a 
" delay.
" nnoremap j :m .+1<CR>==
" nnoremap k :m .-2<CR>==
" vnoremap j :m '>+1<CR>gv=gv
" vnoremap k :m '<-2<CR>gv=gv
" Align all visually selected lines at the given character ("reformat: align")
" :Tablularize /<char to be used as alignmend>
" Note: A pipe | needs NOT to be escaped.
" 22-06-07: Disabled as almost never used and <leader>r maps are now the refactoring 
" mappings.
" vnoremap <Leader>ra :Tabularize /
" Trigger omnicomplete
" Note: We cannot map this to <C-Space> as this is used as the Prexif for tmux.
" inoremap <C-Space> <C-x><C-o>

"#### Development key mappings
" Location list: Next and previos
nnoremap <Leader>dn :lnext<CR>
nnoremap <Leader>dp :lprev<CR>

set clipboard+=unnamedplus


"#############################
" VSCode commands/keybindings
"#############################
vnoremap <leader>rf <Cmd>call VSCodeNotifyVisual('editor.action.formatSelection')<CR>
vnoremap <leader>c<space> <Cmd>call VSCodeNotifyVisual('editor.action.commentLine')<CR>
nnoremap <leader>rf <Cmd>call VSCodeNotify('editor.action.formatDocument')<CR>
nnoremap <leader>c<space> <Cmd>call VSCodeNotify('editor.action.commentLine')<CR>
nnoremap <leader>fj <Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>
nnoremap <leader>gj <Cmd>call VSCodeNotify('workbench.action.findInFiles')<CR>
nnoremap <leader>lb <Cmd>call VSCodeNotify('workbench.action.quickOpenRecent')<CR>
nnoremap ]c <Cmd>call VSCodeNotify('workbench.action.compareEditor.nextChange')<CR>
nnoremap [c <Cmd>call VSCodeNotify('workbench.action.compareEditor.previousChange')<CR>
nnoremap <leader>rn <Cmd>call VSCodeNotify('editor.action.rename')<CR>
nnoremap ]d <Cmd>call VSCodeNotify('editor.action.marker.next')<CR>
nnoremap [d <Cmd>call VSCodeNotify('editor.action.marker.prev')<CR>
nnoremap <leader>vo <Cmd>call VSCodeNotify('workbench.view.scm')<CR>
nnoremap <leader>lf <Cmd>call VSCodeNotify('editor.action.quickFix')<CR>
nnoremap <leader>ls <Cmd>call VSCodeNotify('editor.action.showHover')<CR>
nnoremap <leader>fo <Cmd>call VSCodeNotify('outline.focus')<CR>
nnoremap <C-w>o <Cmd>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>
nnoremap K <Cmd>call VSCodeNotify('editor.action.peekImplementation')<CR>
nnoremap <leader>db <Cmd>call VSCodeNotify('editor.debug.action.toggleBreakpoint')<CR>
nnoremap <leader>fd <Cmd>call VSCodeNotify('workbench.action.openSettings')<CR>
nnoremap gr <Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>
nnoremap gx <Cmd>call VSCodeNotify('editor.action.openLink')<CR>

nnoremap <leader>ti <Cmd>call VSCodeNotify('workbench.action.terminal.toggleTerminal')<CR>

nnoremap <leader>nf <Cmd>call VSCodeNotify('workbench.files.action.showActiveFileInExplorer')<CR>

nnoremap <leader>jk <Cmd>call VSCodeNotify('vscode-harpoon.addEditor')<CR>
nnoremap <leader>jl <Cmd>call VSCodeNotify('vscode-harpoon.editEditors')<CR>
nnoremap <leader>ja <Cmd>call VSCodeNotify('vscode-harpoon.gotoEditor1')<CR>
nnoremap <leader>js <Cmd>call VSCodeNotify('vscode-harpoon.gotoEditor2')<CR>
nnoremap <leader>jd <Cmd>call VSCodeNotify('vscode-harpoon.gotoEditor3')<CR>
nnoremap <leader>jf <Cmd>call VSCodeNotify('vscode-harpoon.gotoEditor4')<CR>

        "{
            ""before": ["g", "i"],
            ""after": [],
            ""commands": [
                ""editor.action.goToImplementation",
            "]
        "},
        "{
            ""before": ["g", "r"],
            ""after": [],
            ""commands": [
                ""editor.action.goToReferences",
            "]
        "},
        "{
            ""before": ["K"],
            ""after": [],
            ""commands": [
                ""editor.action.showDefinitionPreviewHover",
            "]
        "},

