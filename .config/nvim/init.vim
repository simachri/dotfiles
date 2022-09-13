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
" Alternative:
"Plug 'shaunsingh/solarized.nvim'
" Plug 'gruvbox-community/gruvbox'

" Statusline
Plug 'famiu/feline.nvim'
Plug 'kyazdani42/nvim-web-devicons'

" Repeat plugin commands, such as vim-surround
Plug 'tpope/vim-repeat'

" Terminal
Plug 'voldikss/vim-floaterm'

" Language server
Plug 'neovim/nvim-lspconfig'
"Plug 'lspcontainers/lspcontainers.nvim'
" Icons for LSP items
Plug 'onsails/lspkind-nvim'
Plug 'leafOfTree/vim-svelte-plugin'
" JavaScript/TypeScript
Plug 'jose-elias-alvarez/typescript.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'
"" Python: Add import for word under cursor if already imported before.
"Plug 'tjdevries/apyrori.nvim', { 'for': 'python' }
" Python: Activate virtual environments automatically.
Plug 'rafi/vim-venom', { 'for': 'python' }
" Python: formatter as pyright does not inlcude one.
" HTML: formatter
Plug 'sbdchd/neoformat'
" HTML: Auto-close tags - is enabled through the treesitter configuration.
Plug 'windwp/nvim-ts-autotag'
" Automatically insert matching bracket.
Plug 'windwp/nvim-autopairs'

" Completion engine with completion sources
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-calc'
Plug 'saadparwaiz1/cmp_luasnip'
"Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }
Plug 'tzachar/fuzzy.nvim' " requires 'nvim-telescope/telescope-fzf-native.nvim', see below
"Plug 'tzachar/cmp-fuzzy-buffer'
Plug 'petertriho/cmp-git'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'

Plug 'godlygeek/tabular'
Plug 'dhruvasagar/vim-table-mode'
Plug 'scrooloose/nerdcommenter'
Plug 'mbbill/undotree'
Plug 'tpope/vim-surround'

" File manager
Plug 'mcchrish/nnn.vim'

" Tags and outline
" Plug 'simrat39/symbols-outline.nvim'

Plug 'Chiel92/vim-autoformat', { 'for': 'python' }
" Easier profiling of Vim startup time:
Plug 'tweekmonster/startuptime.vim'

" Markdown
Plug 'ixru/nvim-markdown'
Plug 'ferrine/md-img-paste.vim'
" Preview: Does not work with WSL
"function! BuildComposer(info)
"  if a:info.status != 'unchanged' || a:info.force
"      !cargo build --release --locked
"  endif
"endfunction
"Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }

"" Pandoc
"Plug 'vim-pandoc/vim-pandoc'
"Plug 'vim-pandoc/vim-pandoc-syntax'

" Cheat Sheet
Plug 'RishabhRD/popfix'
Plug 'RishabhRD/nvim-cheat.sh'

" Debugging: Since NeoVim 0.6, there is a native DAP support.
" Migrate from Vimspector to DAP.
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'nvim-telescope/telescope-dap.nvim'
"Plug 'yriveiro/dap-go.nvim'

" The following plugins are required for other nvim plugins.
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
" Telescope
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-ui-select.nvim'
" File navigation/marks
Plug 'ThePrimeagen/harpoon'
Plug 'rmagatti/auto-session'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/nvim-treesitter-context'

Plug 'ThePrimeagen/refactoring.nvim'

" Golang
" 21-05-13: Removed in favour of native lsp.
"Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'sebdah/vim-delve'
Plug 'ray-x/go.nvim'
Plug 'ray-x/guihua.lua' " float term, codeaction and codelens gui support

" Snippets
Plug 'L3MON4D3/LuaSnip'

" Show marks and registers content.
Plug 'folke/which-key.nvim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'sindrets/diffview.nvim'
" Plug 'TimUntersberger/neogit' 2022-09-05: Still not as good as fugitive.
Plug 'lewis6991/gitsigns.nvim'

Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }

" Indenting lines
Plug 'lukas-reineke/indent-blankline.nvim'

call plug#end()

" Needs to be called before feline.
set termguicolors

luafile ~/.config/nvim/lua/plugin/telescope.lua
luafile ~/.config/nvim/lua/plugin/treesitter.lua
luafile ~/.config/nvim/lua/plugin/feline.lua
luafile ~/.config/nvim/lua/plugin/nvim-lspconfig.lua
luafile ~/.config/nvim/lua/plugin/nvim-cmp.lua
" Superseded by Telescope function:
"luafile ~/.config/nvim/lua/plugin/symbols-outline.lua
luafile ~/.config/nvim/lua/plugin/luasnip.lua
luafile ~/.config/nvim/lua/plugin/which-key.lua
luafile ~/.config/nvim/lua/plugin/harpoon.lua
luafile ~/.config/nvim/lua/plugin/auto-session.lua
luafile ~/.config/nvim/lua/plugin/nvim-dap.lua
luafile ~/.config/nvim/lua/plugin/go-nvim.lua
luafile ~/.config/nvim/lua/plugin/refactoring.lua
luafile ~/.config/nvim/lua/plugin/nvim-web-devicons.lua
luafile ~/.config/nvim/lua/plugin/git.lua
luafile ~/.config/nvim/lua/plugin/colorscheme.lua

""""""""""""""""""""""
" General Vim settings
""""""""""""""""""""""
lua << EOF
require("nvim-autopairs").setup {}
EOF
"" Show trailing spaces and tabs
"set list
"set listchars=tab:▶\ 
"set listchars=tab:▶\ ,trail:·
" Always use the block cursor
set guicursor=
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

"" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
"" delays and poor user experience.
"set updatetime=50

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
set undodir=~/.vim/undodir
set undofile
"" Highlight the current line.
set cursorline
" Make it so there are always eight lines below my cursor
set scrolloff=8
set noswapfile
set nobackup
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" Indenting configuration
" https://github.com/lukas-reineke/indent-blankline.nvim
let g:indent_blankline_filetype_exclude = [ 'markdown', 'taskedit', 'lspinfo', 'packer', 'checkhealth', 'help', '', ]
let g:indent_blankline_show_first_indent_level = v:false
highlight IndentBlanklineIndent1 guifg=#eee8d5 gui=nocombine
highlight Visual guifg=#fdf6e3 guibg=#93a1a1 gui=nocombine
lua << EOF
require("indent_blankline").setup {
    char_highlight_list = {
        "IndentBlanklineIndent1",
    },
}
EOF
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

" Use relative line numbers.
set number relativenumber
" Always show sign column of width 2.
set scl=yes:2


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
" Show a vertical bar at column X
set colorcolumn=90
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


""""""""""""""""
" Scratch buffer
""""""""""""""""
function! OpenScratchBuffer()
" Check if a scratch buffer already exists.
lua << EOF
      if vim.fn.bufnr("scratch") ~= -1 then
        vim.cmd("e scratch")
        return
      else
        vim.cmd([[
          "vsplit
          noswapfile hide enew
          setlocal buftype=nofile
          setlocal bufhidden=hide
          setlocal tw=0
          "setlocal ft=pandoc
          setlocal ft=markdown
          "lcd ~
          file scratch
          ]])
      end
EOF
endfunction
command! OpenScratchBuffer call OpenScratchBuffer()
nnoremap <Leader>i :OpenScratchBuffer<CR>


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

""""""""""
" Firenvim
""""""""""
" https://github.com/glacambre/firenvim
let g:firenvim_config = { 
    \ 'globalSettings': {
        \ 'alt': 'all',
    \  },
    \ 'localSettings': {
        \ '.*': {
            \ 'cmdline': 'neovim',
            \ 'content': 'text',
            \ 'priority': 0,
            \ 'selector': 'textarea',
            \ 'takeover': 'never',
            \ 'filename': '/tmp/{pathname%32}.{extension}',
        \ },
    \ }
\ }
function! OnUIEnter(event) abort
  if 'Firenvim' ==# get(get(nvim_get_chan_info(a:event.chan), 'client', {}), 'name', '')
    " To create mappings for increasing and decreasing the font size through a key mapping, 
    " see https://github.com/glacambre/firenvim/issues/972#issuecomment-843733076.
    let s:fontsize = 16
    function! AdjustFontSizeF(amount)
      let s:fontsize = s:fontsize+a:amount
      "execute "set guifont=SauceCodePro\\ NF:h" . s:fontsize
      execute "set guifont=MesloLGLDZ\\ NF:h" . s:fontsize
      call rpcnotify(0, 'Gui', 'WindowMaximized', 1)
    endfunction

    nnoremap  <C-+> :call AdjustFontSizeF(1)<CR>
    nnoremap  <C--> :call AdjustFontSizeF(-1)<CR>
   " set guifont=SauceCodePro\ NF:h16
    set guifont=MesloLGLDZ\ NF:h16
    set lines=70
    set columns=110
    " Setting the filetype here has no effect as it is derived from the (temporary) file 
    " that is being created and edited.
    " set ft=markdown
    " https://github.com/glacambre/firenvim#using-different-settings-depending-on-the-pageelement-being-edited
    au BufEnter *.txt set filetype=confluencewiki
  endif
endfunction
autocmd UIEnter * call OnUIEnter(deepcopy(v:event))
