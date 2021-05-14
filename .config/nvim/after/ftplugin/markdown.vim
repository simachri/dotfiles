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


""""""""""""""""""""""""""""""""""""""
" Keymaps
""""""""""""""""""""""""""""""""""""""
" "Find header", previously "Find tags"
noremap <buffer> <Leader>fh :TagbarOpenAutoClose<CR>
