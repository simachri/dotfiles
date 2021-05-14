set nocompatible

if has('multi_byte')
      set encoding=utf-8
      setglobal fileencoding=utf-8
      set fileencoding=utf-8
endif

syntax enable
filetype plugin indent on

" https://stackoverflow.com/a/446293
nnoremap <Space> <nop>
let mapleader=" "

call plug#begin('~/.config/nvim/plugged')
" Colorscheme
Plug 'ishan9299/nvim-solarized-lua'

" 21-03-13, go for more performant status line
"" Theming for statusline.
Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}
Plug 'kyazdani42/nvim-web-devicons'

" Repeat plugin commands, such as vim-surround
Plug 'tpope/vim-repeat'

" Bufferline
Plug 'akinsho/nvim-bufferline.lua'

" Language server
Plug 'neovim/nvim-lspconfig'
Plug 'lspcontainers/lspcontainers.nvim'

" Autocomplete
Plug 'hrsh7th/nvim-compe'
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'deoplete-plugins/deoplete-lsp'
" Python: Add import for word under cursor if already imported before.
Plug 'tjdevries/apyrori.nvim'

Plug 'godlygeek/tabular'
Plug 'dhruvasagar/vim-table-mode'
Plug 'scrooloose/nerdcommenter'
" 2020-12-04, use undotree instead as gundo does not work with python3
Plug 'mbbill/undotree'
Plug 'tpope/vim-surround'

Plug 'kyazdani42/nvim-tree.lua'

" Tags and outline
Plug 'majutsushi/tagbar'
Plug 'simrat39/symbols-outline.nvim'

Plug 'alvan/vim-closetag'
Plug 'Chiel92/vim-autoformat'
" Easier profiling of Vim startup time:
Plug 'tweekmonster/startuptime.vim'

" Markdown
Plug 'plasticboy/vim-markdown'
" Use installation method when node.js and yarn is already installed.
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'jszakmeister/markdown2ctags'
Plug 'ferrine/md-img-paste.vim'

"" Pandoc
"Plug 'vim-pandoc/vim-pandoc'
"Plug 'vim-pandoc/vim-pandoc-syntax'

"Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
"Plug 'junegunn/fzf.vim'

" Debugging
Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer'

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
" Plug 'nvim-telescope/telescope-fzf-writer.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Golang
" 21-05-13: Removed in favour of native lsp.
"Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'sebdah/vim-delve'

call plug#end()

luafile ~/.config/nvim/lua/plugin/bufferline.lua
luafile ~/.config/nvim/lua/plugin/telescope.lua
luafile ~/.config/nvim/lua/plugin/treesitter.lua
luafile ~/.config/nvim/lua/plugin/galaxyline.lua
luafile ~/.config/nvim/lua/plugin/nvim-lspconfig.lua
luafile ~/.config/nvim/lua/plugin/nvim-compe.lua
luafile ~/.config/nvim/lua/plugin/symbols-outline.lua



""""""""""""""""""""""
" General Vim settings
""""""""""""""""""""""
" Always use the block cursor
set guicursor=
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
set undodir=~/.vim/undodir
set undofile
"" Highlight the current line.
"set cursorline
" Make it so there are always eight lines below my cursor
set scrolloff=8
set noswapfile
set nobackup
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors
"" 21-1-19, Use this to make colors in Vim work with rxvt-unicode.
"set t_Co=256

set background=light
" Adjust solarized8 colorscheme. Needs to be located BEFORE the colorscheme is loaded.
augroup adj_solarized
  au!
  " ~/.config/nvim/plugged/vim-solarized8/colors/solarized8.vim
  " Default colors:
  " - green - `Statement`: `#859900`
  " - red - `Title`:  #cb4b16
  " - orange - `Type`: `#b58900`
  " - purple - `Underlined`: `#6c71c4`
  " - blue - `Identifier`: `#268bd2`
  " - cyan - `Constant`: `#2aa198`
  " - grey - `Comment`: `#93a1a1` 
  " Adjust 'blue'
  " au ColorScheme * hi Identifier guifg=#507da9
  " Adjust 'red'
  au ColorScheme * hi Title guifg=#cd6a46 guibg=NONE gui=bold cterm=bold
  "" Adjust 'cyan'
  "au ColorScheme * hi Constant guifg=#298a81
  "" Override background color of the line number bar
  " highlight LineNr guifg=#839496 guibg=#eee8d5
  au ColorScheme * hi clear LineNr
  " hi CursorLineNr guifg=#cb4b16 guibg=#073642 gui=bold cterm=bold
  au ColorScheme * hi CursorLineNr guibg=None
  " Statusline of non-current buffers
  au ColorScheme * hi StatusLineNC guibg=#839496 guifg=#eee8d5
  """ Treesitter: https://github.com/nvim-treesitter/nvim-treesitter/blob/master/plugin/nvim-treesitter.vim
augroup END

" colorscheme solarized
colorscheme solarized-flat

" 21-03-09: Fix neovim issues with clipboard not working.
set clipboard+=unnamedplus
set clipboard+=unnamed
set splitbelow
set splitright
" 20-12-31 Disabled as it messes around with Golang omnicompletion, see below.
" set omnifunc=syntaxcomplete#Complete " set default omnicompletion
set showcmd
set laststatus=2
set noerrorbells visualbell t_vb=
augroup MY_VIMRC
  autocmd!
  autocmd GUIEnter * set visualbell t_vb=
augroup END
" Set spell checking language
" set spelllang=en,de_19
set nospell
" Enable the creation of new buffers without the restriction
" to save the currently open buffer
set hidden
" Disable delay when pressing Esc
:set timeoutlen=1000 ttimeoutlen=0
" Pasting
set pastetoggle=<F2>
"" Show a vertical bar at column 91
" set colorcolumn=91

" Concealing/appearance
" 21-01-16: Set this to 0 instead of 2 for better performance.
set conceallevel=0

" 21-02-15 - disabled as it seems to open multiple buffers when using in the markdown 
" context
"" Create 'views' when exiting a window and load it when entering it.
"set viewoptions=cursor
"au BufWinLeave *.* mkview
"au BufWinEnter *.* silent loadview
" Custom command :Delview to delete the view: https://stackoverflow.com/a/28460676
" # Function to permanently delete views created by 'mkview'
function! MyDeleteView()
    let path = fnamemodify(bufname('%'),':p')
    " vim's odd =~ escaping for /
    let path = substitute(path, '=', '==', 'g')
    if empty($HOME)
    else
        let path = substitute(path, '^'.$HOME, '\~', '')
    endif
    let path = substitute(path, '/', '=+', 'g') . '='
    " view directory
    let path = &viewdir.'/'.path
    call delete(path)
    echo "Deleted: ".path
endfunction
" # Command Delview (and it's abbreviation 'delview')
command Delview call MyDeleteView()

"" 21-1-16: Try to make Vim faster in large files.
"" Source: https://stackoverflow.com/a/378967
"set lazyredraw

" Use relative line numbers
set number relativenumber


"""""""""""
" Searching
""""""""""""
" Do not keep the last search result highlighted.
set nohlsearch
" 'Toggle highlighted' search results
nnoremap <silent> <Leader>th :set hlsearch!<CR>
set incsearch
set ignorecase
set smartcase
" Search for visual selection
vnoremap // y/<C-R>"<CR>


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

"""""""""""""""""""""
" Custom key mappings
"""""""""""""""""""""
" Close current buffer
nnoremap <C-w>d :bd<CR>
" Let Y yank to end of line instead of entire line.
nnoremap Y y$
"" Remove DOS line endings ^M 'reformat/remove m'
"nnoremap <silent> <Leader>rm :%s/\r//g<CR>
"" 'set filetype dosini'
"nnoremap <silent> <Leader>sd :%s/\r//g<CR>
set nowrap
" Toggle wrap
nnoremap <silent> <Leader>tw :set wrap!<CR>
" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %
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
nnoremap <silent> <Leader>rrw :%s/\<<C-r><C-w>\>//gI<Left><Left><Left>
" Replace selection
vnoremap <silent> <Leader>rrw "sy:%s/<C-r>s//gI<Left><Left><Left>
" Remap the join lines J command, such that the cursor remains at the position
" Source: https://stackoverflow.com/questions/9505198/join-two-lines-in-vim-without-moving-cursor
:nnoremap <silent> J :let p=getpos('.')<bar>join<bar>call setpos('.', p)<cr>
" Set save key mapping.
nnoremap <silent> <Leader>s :update!<CR>
" Switch to next and previous buffer.
nnoremap <C-H> :bp<CR>
nnoremap <C-L> :bn<CR>
" Yank the full filepath into the clipboard.
nnoremap <Leader>yp :let @+=expand('%:p')<CR>
" Yank the current working directory into the clipboard.
nnoremap <Leader>yc :let @+=getcwd()<CR>
" For XML files use a specific formatter for
" gg=G  (format everything)
" " Requires 'xmllint' (sudo apt-get install libxml2-utils)
" au FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null
" autocmd FileType xml setlocal equalprg=tidy\ -quiet\ --show-errors\ 0 2>/dev/null
" autocmd FileType xml let g:formatprg_args_expr_xml .= '." --indent-attributes 1"'
" Format selection
vnoremap <Leader>f :!tidy -xml -q -i --show-errors 0 --indent-attributes 1 -<CR>
" Moving lines up and down
" 2020-12-18, Disable this as this somehow conflicts when using `ESCAPE` which causes a 
" delay.
" nnoremap j :m .+1<CR>==
" nnoremap k :m .-2<CR>==
" vnoremap j :m '>+1<CR>gv=gv
" vnoremap k :m '<-2<CR>gv=gv
" Align all visually selected lines at the given character
" Note: A pipe | needs to be escaped, that is, \|
vnoremap <Leader>df :Tabularize/
" Remap the q: (command history) for the use with FZF
nnoremap q: :History:<CR>
" Remap the q/ (search history) for the use with FZF
nnoremap q/ :History/<CR>
" Trigger omnicomplete
" Note: We cannot map this to <C-Space> as this is used as the Prexif for tmux.
" inoremap <C-Space> <C-x><C-o>

"#### Development key mappings
" Location list: Next and previos
nnoremap <Leader>dn :lnext<CR>
nnoremap <Leader>dp :lprev<CR>


"""""""
" LateX
"""""""
let g:vimtex_quickfix_ignored_warnings = [
         \ 'possible unwanted space',
       \ ]
"let g:vimtex_quickfix_ignore_all_warnings = 1
let g:vimtex_fold_enabled = 1
let g:vimtex_latexmk_continuous = 1
" " Map LaTeX compilation
" map <Leader>vt :! rm ausarbeitung.pdf<CR>:VimtexCompileToggle<CR><CR>:VimtexView<CR>
augroup vimrc_autocmds
  autocmd!
  autocmd BufNewFile,BufRead *.bib,*.tex set iskeyword+=_ iskeyword+=@
  au FileType tex set smartindent&
  au FileType tex set cindent&
  au FileType tex set autoindent&
  au FileType tex set indentexpr&
  au FileType plaintex set smartindent&
  au FileType plaintex set cindent&
  au FileType plaintex set autoindent&
  au FileType plaintex set indentexpr&
augroup END


""""""""
" Tags
""""""""
let g:tagbar_width = 80
" CTags: Search for tag file recursively upwards until the home directory
" Source: https://stackoverflow.com/a/741486
" Help: :h tags
set tags=./tags;,tags;


"""""""""""
"" Deoplete
"""""""""""
"let g:deoplete#enable_at_startup = 1
"" call deoplete#custom#option('auto_complete_delay', 200)
"" Disable when showing TelescopePrompt
"augroup disable_deoplete
"  autocmd!
"  autocmd FileType TelescopePrompt call deoplete#disable()
"      \| autocmd BufLeave <buffer> call deoplete#enable()
"augroup END
"" Configuration of 'deoplete-plugins/deoplete-lsp':
"let g:deoplete#lsp#use_icons_for_candidates = v:true

""""""""""""""""
" Vim table-mode
""""""""""""""""
let g:table_mode_corner='|'
let g:table_mode_corner_corner='|'
" We use the fillchar - to make the markdown preview properly render.
let g:table_mode_header_fillchar='-'
let g:table_mode_syntax = 0

""""""
"" fzf
""""""
"" Set runtime path
"set rtp+=~/.fzf
"" By default fzf will spawn a popup window in an own terminal session. This is rather slow.
"" Make it spawn at the bottom instead, which is much faster:
"" let g:fzf_layout = { 'down': '40%' }
"" let g:fzf_prefer_tmux = 1
"" Remove status line in results window
"augroup fzf
"  autocmd! FileType fzf
"  autocmd  FileType fzf set laststatus=0 noshowmode noruler
"    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
"augroup END
"" Mapping selecting mappings
"nmap <leader><tab> <plug>(fzf-maps-n)
"xmap <leader><tab> <plug>(fzf-maps-x)
"omap <leader><tab> <plug>(fzf-maps-o)
""" Insert mode completion
""imap <c-x><c-k> <plug>(fzf-complete-word)
""" inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'window': { 'width': -1.2, 'height': 0.9, 'xoffset': 1 }})
""imap <c-x><c-f> <plug>(fzf-complete-path)
"" Use this complex command to prevent the issue that a blank space is inserted in front of the word.
"" imap <c-x><c-j> <plug>(fzf-complete-file)
"inoremap <expr> <c-x><c-j> fzf#vim#complete#path("find . -path '*/\.*' -prune -o -type f -print -o -type l -print \| sed 's:^..::'")
""imap <c-x><c-l> <plug>(fzf-complete-buffer-line)
"" Add <C-c> keymap to yank the filename in an fzf result list to default register +
"let g:fzf_action = {
"      \ 'ctrl-t': 'tab split',
"      \ 'ctrl-x': 'split',
"      \ 'ctrl-v': 'vsplit',
"      \ 'ctrl-c': {lines -> setreg('+', join(lines, "\n"))}}
"nnoremap <Leader>tf :Files .<CR>
"nnoremap <Leader>tb :Buffer<CR>
"" fzf: ripgrep wrapper
"" --column: Show column number
"" --line-number: Show line number
"" --no-heading: Do not show file headings in results
"" --fixed-strings: Search term as a literal string
"" --ignore-case: Case insensitive search
"" --no-ignore: Do not respect .gitignore, etc...
"" --hidden: Search hidden files and folders
"" --follow: Follow symlinks
"" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
"" --color: Search color options
"" Source: https://github.com/junegunn/fzf.vim
"function! RipgrepFzf(query, fullscreen)
"  let command_fmt = 'rg --line-number --no-heading --color=always --ignore-case -- %s || true'
"  let initial_command = printf(command_fmt, shellescape(a:query))
"  let reload_command = printf(command_fmt, '{q}')
"  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
"  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
"endfunction
"command! -nargs=* -bang Find call RipgrepFzf(<q-args>, <bang>0)
"" Grep
"nnoremap <Leader>tg :Find 
""" Find word under cursor - note: conflicts with 'toggle wrap'
""nnoremap <Leader>tw :Find <C-r><C-w><CR>
"" Find anchor
"nnoremap <Leader>ta :Find id="<C-r><C-w><CR>
"" Find visual selection
"vnoremap <Leader>fs "sy:Find <C-r>s<CR>

""""""""""
" Markdown
""""""""""
" Disable automatical pull of a # to the beginning of the line.
" au! FileType markdown set nosmartindent
" au! FileType markdown set indentkeys-=0#

" 21-1-16: Disable conceal which improves performance for Vim markdown files.
let g:vim_markdown_conceal=0
let g:vim_markdown_conceal_code_blocks = 0
" " Only conceal in 'normal' and 'command' mode
" set concealcursor=nc
" Enable strikethrough
let g:vim_markdown_strikethrough = 1
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_no_extensions_in_markdown = 0
" Add support for markdown files in tagbar.
let g:tagbar_type_markdown = {
    \ 'ctagstype': 'markdown',
    \ 'ctagsbin' : '~/.config/nvim/plugged/markdown2ctags/markdown2ctags.py',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }
"" Add support for markdown (pandoc flavour) files in tagbar.
"" Source: https://stackoverflow.com/a/58768939
"let g:tagbar_type_pandoc = {
"    \ 'ctagstype': 'pandoc',
"    \ 'ctagsbin' : '~/.vim/plugged/markdown2ctags/markdown2ctags.py',
"    \ 'ctagsargs' : '-f - --sort=yes',
"    \ 'kinds' : [
"        \ 's:sections',
"        \ 'i:images'
"    \ ],
"    \ 'sro' : '|',
"    \ 'kind2scope' : {
"        \ 's' : 'section',
"    \ },
"    \ 'sort': 0,
"\ }
" Set {anchor} as the anchor expression - this is aligned with Pandoc's anchor mechanism.
" Note: When setting the anchor, use {#<anchor name>}, e.g. {#my-anchor} such that
" Pandoc omits the anchor in the heading when rendered.
" 2020-12-26 Changed to make it work with the GitHub markdown flavour style, that is,
" use <a id="<anchor>"></a> as an anchor. This has the following advantages:
" - No {#<anchor>} expressions displayed.
" - Yanking the anchor becomes quicker.
" let g:vim_markdown_anchorexpr = "'{#'.v:anchor.'}'"
let g:vim_markdown_anchorexpr = "'id=\"'.v:anchor.'\"'"

" Follow anchors with 'ge' in links that lack the markdown extension.
" This behaviour makes the links compatible when uploaded to Djanog wiki.
let g:vim_markdown_no_extensions_in_markdown = 1

" Disable markdown folding as it dramatically slows down performance.
let g:vim_markdown_folding_disabled=1
let g:vim_markdown_override_foldtext=1
let g:vim_markdown_folding_style_pythonic=0
let g:vim_markdown_folding_level = 4

" Set the syntax highlighting to work on larger fenced code blocks.
let g:markdown_minlines = 50

" Backup: Create a complete anchor link for the current header when the header has format
" # This is a header text {#anchor}
" 1. Clear register d
" 2. Search for the anchor in the current line, that is, {#anchor-name} and match
"    everything between {# and }.
" 3. Yank everything between the first # (beginning of header) and the {# into register f.
" 4. Yank the match to register d.
" 5. Disable highlighting of search results.
" nnoremap <Leader>a qdq:s/{#\zs.*\ze}/\=setreg('d', submatch(0))/n<CR>
"          \0wvt{be"fy
"          \:let
"          \@+="[".@f."]
"          \(".@%."#".@d.")"<CR>
"          \:nohlsearch<CR>
" Create a complete anchor link of format [filename wo ext](#anchor-link)
" 1. Clear register d
" 2. Search for the anchor in the current line, that is, <a id="anchor-name"></a> and match
"    everything in the double quotes.
" 3. Yank the match to register d.
" 4. Disable highlighting of search results.
augroup MARKDOWN
  autocmd!
  " Currently not used: Create a full anchor link
  "autocmd FileType markdown nnoremap <Leader>al qdq:s/<a id="\zs.*\ze"><\/a>/\=setreg('d', submatch(0))/n<CR>
  "                  \:let @+="[".substitute(substitute(substitute(@%, "__", " ", "g"), "_", " ", "g"), ".md", "", "")."]
  "                  \(".@%."#".@d.")"<CR>
  "                  \:nohlsearch<CR>
  " 'Get anchor' link without the filename as the link description.
  autocmd FileType markdown nnoremap <Leader>ga qdq:s/<a id="\zs.*\ze"><\/a>/\=setreg('d', submatch(0))/n<CR>
                    \:let @+="(".expand('%:r')."#".@d.")"<CR>
                    \:nohlsearch<CR>
  " 'Add anchor'
  autocmd FileType markdown nnoremap <Leader>aa o<a id=""></a><Esc>5hi
  " Use ge in markdown files to follow link and open in horizontal split.
  autocmd FileType markdown nmap <buffer> ge m'<Plug>Markdown_EditUrlUnderCursor
  " Use gs in markdown files to follow link and open in vertical split.
  autocmd FileType markdown nmap <buffer> gs m'<C-W>v<Plug>Markdown_EditUrlUnderCursor

  " Paste image: 'ferrine/md-img-paste.vim'
  autocmd FileType markdown nmap <buffer><silent> <leader>pi :call mdip#MarkdownClipboardImage()<CR>
augroup END

" Follow anchors, that is, the `ge` command will jump to the anchor <file>#<anchor>.
let g:vim_markdown_follow_anchor=1
" Paste image: 'ferrine/md-img-paste.vim'
" there are some defaults for image directory and image name, you can change them
let g:mdip_imgdir = '.images'
let g:mdip_imgname = 'img'

" Convert an legacy anchor {#anchor} into a new anchor <a id="anchor"></a>.
" 1. Clear register f.
" 2. Search for the legacy anchor in the current line, that is, {#anchor-name} and match
"    everything between {# and }.
" 3. Yank the match to register f.
" 4. Delete the legacy anchor.
" 5. Go back to the previously visited location (otherwise we are at the first character 
"    in the line).
" 6. Insert a new anchor and paste the contents from register f.
" 7. Disable highlighting of search results.
nnoremap <Leader>ac qfq:s/{#\zs.*\ze}/\=setreg('f', submatch(0))/n<CR>
          \:s/{#.*}/<a id=\"<C-r>f\"><\/a>/<CR>
          \:nohlsearch<CR>

" Keymap to sync syntax highlighting again if it is broken.
nnoremap <silent> <Leader>e mx:e<CR>:syntax sync fromstart<CR>`x

" 'Convert header' Convert a righ-aligned line to a second-level markdown header
nnoremap <Leader>ch ^xf`x0cw## <C-[>
" Markdown preview
" Use commands :MarkdownPreview and :MarkdownPreviewStop instead
" nmap <Leader>p <Plug>MarkdownPreviewToggle
" let g:mkdp_browser = 'qutebrowser'
" For additional filetype settings regarding markdown see
" ~/.vim/after/ftplugin/markdown.vim


""""""""""""""""
" Scratch buffer
""""""""""""""""
function! CreateScratchBuffer()
    vsplit
    noswapfile hide enew
    setlocal buftype=nofile
    setlocal bufhidden=hide
    "setlocal ft=pandoc
    setlocal ft=markdown
    "lcd ~
    file scratch
endfunction
command! NewScratchBuf call CreateScratchBuffer()
nnoremap <Leader>i :NewScratchBuf<CR>


"""""""""""""""""
" Markdown server
"""""""""""""""""
" Function to send the currently opened file to the markdown server container in the 
" Kubernetes cluster.
function! SendToGKE()
  let parent_dir=expand('%:p:h:t')
  let fname_ext=substitute(substitute(expand('%'), "__", " ", "g"), "_", " ", "g")
" The redraw! is required to update Vim's screen after the command has been executed.
  execute
   \ "!kubectl cp " . expand('%:p') .
   \ " 'md-madness-web/md-madness-web-68994cc498-7hf5n:/docs/" . parent_dir . "/" . fname_ext . "'" 
   \ | redraw!
endfunction
command SendToGKE call SendToGKE()


"""""""""""""""""""""""""
" Go syntax highlighting
"""""""""""""""""""""""""
" We set this here to have the syntax highlighting properly applied when the file is 
" opened.
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_types = 1
" Auto formatting on save
let g:go_fmt_autosave = 1
" Run :GoImports on save
let g:go_fmt_command = "goimports"
" Disable automatic types/signatures info for the word under the cursor.
let g:go_auto_type_info = 0
