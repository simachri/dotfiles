" 'Convert header' Convert a righ-aligned line to a second-level markdown header
nnoremap <Leader>ch ^xf`x0cw## <C-[>

" Good guide: https://blog.siddharthkannan.in/vim/configuration/2019/11/02/format-list-pat-and-vim/
" Prevent automatic leader insertion after using the gq command for reformatting:
" - the default regex is ^\\s*\\d\\+\\.\\s\\+\\\|^[-*+]\\s\\+\\\|^\\[^\\ze[^\\]]\\+\\]:
"   see /usr/share/vim/vim82/ftplugin/markdown.vim
" - added the \s* in the middle:
setlocal formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\|^\\s*[-*+]\\s\\+\\\|^\\[^\\ze[^\\]]\\+\\]:

"q	Allow formatting of comments with "gq".
"	Note that formatting will not change blank lines or lines containing
"	only the comment leader.  A new paragraph starts after such a line,
"	or when the comment leader changes.
"r	Automatically insert the current comment leader after hitting
"	<Enter> in Insert mode.
"o	Automatically insert the current comment leader after hitting 'o' or
	"'O' in Normal mode.
"t	Auto-wrap text using textwidth
"       is always set by: /usr/share/vim/vim82/ftplugin/markdown.vim
" setlocal fo-=t fo-=q fo-=r
setlocal formatoptions=Mwjlnt

" Prevent jumping to beginning of line when insertin a '#'.
" See also: ~/.config/nvim/plugged/vim-markdown/indent/markdown.vim
set indentkeys=

"" Disable relative line numbers.
"setlocal nonumber norelativenumber
"" Set width of sign column to 1.
"set scl=yes:1
" Disable sign column.
set scl=no
" Set minimal line number column width.
set numberwidth=6

" Make text italic.
nmap <buffer><silent> <leader>mi ysiW_
" Make text bold.
nmap <buffer><silent> <leader>mb ysiW_.

" 'Add anchor'
nnoremap <Leader>aa o<a id=""></a><Esc>5hi
" 'Get anchor' link without the filename as the link description.
" 1. Clear register d
" 2. Search for the anchor in the current line, that is, <a id="anchor-name"></a> and 
"    match
"    everything in the double quotes.
" 3. Yank the match to register d.
" 4. Disable highlighting of search results.
nnoremap <Leader>ga qdq:s/<a id="\zs.*\ze"><\/a>/\=setreg('y', submatch(0))/n<CR>
                  \:let @x=expand('%:r')<CR>
                  \:nohlsearch<CR>
                  \:echo('Anchor copied to clipboard.')<CR>
                  "\:let @+="(".expand('%:r')."#".@d.")"<CR>

nnoremap <buffer><silent> <leader>fm :lua require('telescope.builtin').current_buffer_fuzzy_find({default_text='^## ', prompt_title="Find header", sorting_strategy="ascending", preview=false, tiebreak=function(picker,current_entry,existing_entry) return false end, layout_strategy="center", layout_config={height=0.7, width=0.8}})<cr>
" nnoremap <buffer><silent> <leader>fm :lua require('telescope.builtin').current_buffer_fuzzy_find({default_text='^## ', prompt_title="Find header", sorting_strategy="ascending", preview=false, tiebreak=function(picker,current_entry,existing_entry) return false end, layout_config={prompt_position="bottom",}})<cr>

" Paste image
nnoremap <buffer><silent> <leader>mi :PasteImg<cr>
" Start preview
nnoremap <buffer><silent> <leader>mp :MarkdownPreview<cr>
