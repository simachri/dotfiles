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
Plug 'gruvbox-community/gruvbox'

" 21-03-13, go for more performant status line
Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}
Plug 'kyazdani42/nvim-web-devicons'

" Repeat plugin commands, such as vim-surround
Plug 'tpope/vim-repeat'

" Bufferline
"Plug 'akinsho/nvim-bufferline.lua'

" Terminal
Plug 'voldikss/vim-floaterm'

" Language server
Plug 'neovim/nvim-lspconfig'
Plug 'lspcontainers/lspcontainers.nvim'
" Icons for LSP items
Plug 'onsails/lspkind-nvim'
" TypeScript
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
Plug 'jose-elias-alvarez/null-ls.nvim'
" Python: Add import for word under cursor if already imported before.
Plug 'tjdevries/apyrori.nvim', { 'for': 'python' }
" Python: Activate virtual environments automatically.
Plug 'rafi/vim-venom', { 'for': 'python' }
" Python: formatter as pyright does not inlcude one.
Plug 'sbdchd/neoformat', { 'for': 'python' }

" Completion engine with completion sources
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'saadparwaiz1/cmp_luasnip'
" Plug 'hrsh7th/nvim-compe' " deprecated
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'deoplete-plugins/deoplete-lsp'

Plug 'godlygeek/tabular'
Plug 'dhruvasagar/vim-table-mode'
Plug 'scrooloose/nerdcommenter'
Plug 'mbbill/undotree'
Plug 'tpope/vim-surround'

" File manager
Plug 'mcchrish/nnn.vim'

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
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'jszakmeister/markdown2ctags'
Plug 'ferrine/md-img-paste.vim'

"" Pandoc
"Plug 'vim-pandoc/vim-pandoc'
"Plug 'vim-pandoc/vim-pandoc-syntax'

" Debugging
Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer'

" The following plugins are required for other nvim plugins.
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
" Telescope
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
" File navigation/marks
Plug 'ThePrimeagen/harpoon'
Plug 'rmagatti/auto-session'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Golang
" 21-05-13: Removed in favour of native lsp.
"Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'sebdah/vim-delve'
Plug 'crispgm/nvim-go'

" Snippets
Plug 'L3MON4D3/LuaSnip'

" Easy reloading of Nvim configuration.
"Plug 'famiu/nvim-reload'

" Show marks and registers content.
Plug 'folke/which-key.nvim'

Plug 'tpope/vim-fugitive'

call plug#end()

"luafile ~/.config/nvim/lua/plugin/bufferline.lua
luafile ~/.config/nvim/lua/plugin/telescope.lua
luafile ~/.config/nvim/lua/plugin/treesitter.lua
luafile ~/.config/nvim/lua/plugin/galaxyline.lua
luafile ~/.config/nvim/lua/plugin/nvim-lspconfig.lua
luafile ~/.config/nvim/lua/plugin/nvim-cmp.lua
luafile ~/.config/nvim/lua/plugin/symbols-outline.lua
luafile ~/.config/nvim/lua/plugin/luasnip.lua
luafile ~/.config/nvim/lua/plugin/which-key.lua
luafile ~/.config/nvim/lua/plugin/harpoon.lua
luafile ~/.config/nvim/lua/plugin/auto-session.lua



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
  " Treesitter: Fix error color group highlighting.
  " https://github.com/nvim-treesitter/nvim-treesitter/issues/119
  au ColorScheme * hi! link TSError Normal
augroup END

" colorscheme solarized
colorscheme solarized-flat

set clipboard+=unnamedplus
" Put the last yank explicitely into xclip when normal yanking did not work in VMware 
" host's clipboard has not been updated.
nnoremap <silent> <leader>yy :call system('xclip', @+)<CR>
"nnoremap <silent> <leader>y "*y
"vnoremap <silent> <leader>y "*y
"" 21-06-02: When yanking from and pasting to NeoVim, use the plus register with xclip:
"let g:clipboard = {
"  \   'name': 'xclip',
"  \   'copy': {
"  \      '*': 'xclip -i -sel primary',
"  \      '+': 'xclip -i -sel clipboard',
"  \    },
"  \   'paste': {
"  \      '*': 'xclip -o -sel primary',
"  \      '+': 'xclip -o -sel clipboard',
"  \   },
"  \   'cache_enabled': 1,
"  \ }
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
set spelllang=en,de
set nospell
" Enable the creation of new buffers without the restriction
" to save the currently open buffer
set hidden
" Yet, do not keep [No Name] buffers open. Wipe them when switchin to another buffer.
" Source: https://stackoverflow.com/a/12328741
if bufname('%') == ''
  set bufhidden=wipe
endif
" Disable delay when pressing Esc
set timeoutlen=600 ttimeoutlen=0
" Pasting
set pastetoggle=<F2>
"" Show a vertical bar at column 91
" set colorcolumn=91

" Concealing/appearance
" 21-01-16: Set this to 0 instead of 2 for better performance.
set conceallevel=0

" 21-02-15 - disabled as it seems to open multiple buffers when using in the markdown 
" context
" Create 'views' when exiting a window and load it when entering it.
set viewoptions=cursor
au BufWinLeave *.* mkview
au BufWinEnter *.* silent! loadview
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
" Use the old regex engine. Seems to be faster in markdown files.
set regexpengine=1

" Use relative line numbers
set number relativenumber



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
nnoremap <leader>ww :!sudo tee > /dev/null %
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
"" Set save key mapping.
"nnoremap <silent> <Leader>s :update!<CR>
" Switch to next and previous buffer.
nnoremap <C-H> :bp<CR>
nnoremap <C-L> :bn<CR>
" 'Yank path': Yank the full filepath into the clipboard.
nnoremap <Leader>yp :let @+=expand('%:p')<CR>
" 'Yank CWD': Yank the current working directory into the clipboard.
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
" Align all visually selected lines at the given character ("reformat: align")
" :Tablularize /<char to be used as alignmend>
" Note: A pipe | needs NOT to be escaped.
vnoremap <Leader>ra :Tabularize /
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


""""""""""""""""
" Vim table-mode
""""""""""""""""
let g:table_mode_corner='|'
let g:table_mode_corner_corner='|'
" We use the fillchar - to make the markdown preview properly render.
let g:table_mode_header_fillchar='-'
let g:table_mode_syntax = 0
" Table format
let g:table_mode_tableize_map = '<Leader>tf'

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

" Create a complete anchor link of format [filename wo ext](#anchor-link)
" 1. Clear register d
" 2. Search for the anchor in the current line, that is, <a id="anchor-name"></a> and match
"    everything in the double quotes.
" 3. Yank the match to register d.
" 4. Disable highlighting of search results.
augroup MARKDOWN
  autocmd!
  " 'Get anchor' link without the filename as the link description.
  autocmd FileType markdown nnoremap <Leader>ga qdq:s/<a id="\zs.*\ze"><\/a>/\=setreg('y', submatch(0))/n<CR>
                    \:let @x=expand('%:r')<CR>
                    \:nohlsearch<CR>
                    \:echo('Anchor copied to clipboard.')<CR>
                    "\:let @+="(".expand('%:r')."#".@d.")"<CR>
  " Currently not used: Create a full anchor link
  "autocmd FileType markdown nnoremap <Leader>al qdq:s/<a id="\zs.*\ze"><\/a>/\=setreg('d', submatch(0))/n<CR>
  "                  \:let @+="[".substitute(substitute(substitute(@%, "__", " ", "g"), "_", " ", "g"), ".md", "", "")."]
  "                  \(".@%."#".@d.")"<CR>
  "                  \:nohlsearch<CR>
  " 'Add anchor'
  autocmd FileType markdown nnoremap <Leader>aa o<a id=""></a><Esc>5hi
  " Use ge in markdown files to follow link and open in horizontal split.
  autocmd FileType markdown nmap <buffer><silent> ge m'<Plug>Markdown_EditUrlUnderCursor
  " Use gs in markdown files to follow link and open in vertical split.
  autocmd FileType markdown nmap <buffer><silent> gs m'<C-W>v<Plug>Markdown_EditUrlUnderCursor
  autocmd FileType markdown nmap <buffer> <silent> [c <Plug>Markdown_MoveToCurHeader
  autocmd FileType markdown nmap <buffer> <silent> [p <Plug>Markdown_MoveToParentHeader
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
" 'Toggle outline
" Provided by plugin https://github.com/simrat39/symbols-outline.nvim
nnoremap <Leader>to :SymbolsOutline<CR>
" Keymap to sync syntax highlighting again if it is broken.
nnoremap <silent> <Leader>e mx:e<CR>:syntax sync fromstart<CR>`x

" 'Convert header' Convert a righ-aligned line to a second-level markdown header
nnoremap <Leader>ch ^xf`x0cw## <C-[>
" Markdown preview
" Use commands :MarkdownPreview and :MarkdownPreviewStop instead
" nmap <Leader>p <Plug>MarkdownPreviewToggle
let g:mkdp_browser = 'brave'
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
    setlocal tw=0
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


""""""""
" Pandoc
""""""""
" Command to export a markdown file as docx to DebianShare/Export_docx
" The file DebianShare/Export_docx/_Pandoc_reference_for_export.docx provides the styles.
"
" The current working directory is temporarily switched to the file's directory such that 
" images are also exported.
"
" +task_lists interprets - [ ] as checkbox
" +pipe_tables interpretes pipe tables
" 
" The redraw! is required to update Vim's screen after the command has been executed.
function! PandocMdToDocx()
  " Change the working directory temporarily.
  lcd %:h
  
  let src_filename = fnameescape(expand('%:p'))
  let dst_filename = input('Enter filename: ' )
  if strlen(dst_filename) == 0
    " %:t:r - select the 'tail' of the path (filename) but without the file extension.
    let today = strftime('%y-%m-%d')
    let dst_filename = '~/VmHostShare/Export/'.fnameescape(expand('%:t:r')).'_'.today.'.docx'
  else
    let dst_filename = '~/VmHostShare/Export/'.dst_filename
  end
  silent execute
    "\ "!pandoc -f markdown+task_lists+pipe_tables
    \ "!pandoc -f gfm
    \ --reference-doc ~/VmHostShare/_Pandoc_reference_21-06-01.docx
    \ -s ".src_filename." -o ".dst_filename | redraw!
  echo dst_filename.' exported.'

  " Change the working directory back.
  lcd -
endfunction
command ToDocx call PandocMdToDocx()
